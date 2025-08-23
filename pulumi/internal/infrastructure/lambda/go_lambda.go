package lambda

import (
	"derma-practice/internal/infrastructure/iam"

	awsiam "github.com/pulumi/pulumi-aws/sdk/v7/go/aws/iam"
	"github.com/pulumi/pulumi-aws/sdk/v7/go/aws/lambda"
	"github.com/pulumi/pulumi-aws/sdk/v7/go/aws/s3"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

type GoLambdaFunction struct {
	pulumi.ResourceState

	Role     *awsiam.Role
	Function *lambda.Function

	Arn  pulumi.StringOutput
	Name pulumi.StringOutput
}

type GoLambdaArgs struct {
	S3Bucket string
	S3Key    string
	Region   string
	// Optional parameters
	MemorySize  pulumi.IntPtrInput
	Timeout     pulumi.IntPtrInput
	Environment pulumi.StringMapInput
}

func NewGoLambdaFunction(
	name string,
	ctx *pulumi.Context,
	args GoLambdaArgs,
) (*GoLambdaFunction, error) {
	component := &GoLambdaFunction{}
	if err := ctx.RegisterComponentResource("custom:component:GoLambdaFunction", name, component); err != nil {
		return nil, err
	}

	role, err := component.createLambdaExecutionRole(ctx, name, args)
	if err != nil {
		return nil, err
	}
	component.Role = role.Role

	function, err := component.createLambdaFunction(ctx, name, args)
	if err != nil {
		return nil, err
	}
	component.Function = function
	component.Arn = function.Arn
	component.Name = function.Name

	if err := component.registerOutputs(ctx); err != nil {
		return nil, err
	}

	return component, nil
}

func (g *GoLambdaFunction) registerOutputs(ctx *pulumi.Context) error {
	return ctx.RegisterResourceOutputs(g, pulumi.Map{
		"arn":  g.Arn,
		"name": g.Name,
	})
}

func (g *GoLambdaFunction) createLambdaExecutionRole(ctx *pulumi.Context, name string, args GoLambdaArgs) (*iam.LambdaExecutionRole, error) {
	roleName := pulumi.Sprintf("%s-exec-%s-%s", name, ctx.Stack(), args.Region)
	role, err := iam.NewLambdaExecutionRole(ctx, name, iam.LambdaExecutionRoleArgs{
		RoleName: roleName,
	})
	if err != nil {
		return nil, err
	}
	return role, nil
}

func (g *GoLambdaFunction) createLambdaFunction(ctx *pulumi.Context, name string, args GoLambdaArgs) (*lambda.Function, error) {
	memorySize := pulumi.IntPtrInput(pulumi.IntPtr(128))
	if args.MemorySize != nil {
		memorySize = args.MemorySize
	}

	timeout := pulumi.IntPtrInput(pulumi.IntPtr(30))
	if args.Timeout != nil {
		timeout = args.Timeout
	}

	bucketObject, err := bucketObjectReference(ctx, name, args)
	if err != nil {
		return nil, err
	}

	functionName := pulumi.Sprintf("go-%s-%s-%s", ctx.Project(), ctx.Stack(), args.Region)
	functionArgs := &lambda.FunctionArgs{
		Name:            functionName,
		Role:            g.Role.Arn,
		Runtime:         pulumi.String("provided.al2023"),
		Handler:         pulumi.String("bootstrap"),
		MemorySize:      memorySize,
		Timeout:         timeout,
		S3Bucket:        bucketObject.Bucket,
		S3Key:           bucketObject.Key,
		S3ObjectVersion: bucketObject.VersionId,
	}

	if args.Environment != nil {
		functionArgs.Environment = &lambda.FunctionEnvironmentArgs{
			Variables: args.Environment,
		}
	}

	lambda, err := lambda.NewFunction(ctx, name, functionArgs, pulumi.Parent(g))

	if err != nil {
		return nil, err
	}
	return lambda, nil
}

func bucketObjectReference(ctx *pulumi.Context, name string, args GoLambdaArgs) (*s3.BucketObjectv2, error) {
	providerID := args.S3Bucket + "/" + args.S3Key
	bucketObject, err := s3.GetBucketObjectv2(ctx, name,
		pulumi.ID(providerID),
		&s3.BucketObjectv2State{
			Bucket: pulumi.String(args.S3Bucket),
			Key:    pulumi.String(args.S3Key),
		})
	if err != nil {
		return nil, err
	}
	return bucketObject, nil
}
