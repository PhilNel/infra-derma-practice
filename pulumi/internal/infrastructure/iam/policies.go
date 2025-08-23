// In internal/infrastructure/iam/policies.go
package iam

import (
	"fmt"

	"github.com/pulumi/pulumi-aws/sdk/v7/go/aws/iam"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

type DynamoDBReadPolicyArgs struct {
	Role     *iam.Role
	TableArn pulumi.StringOutput
	Region   string
}

type LambdaLoggingPolicyArgs struct {
	Role   *iam.Role
	Region string
}

func AttachDynamoDBReadPolicy(ctx *pulumi.Context, name string, args DynamoDBReadPolicyArgs) error {
	policyDoc := pulumi.All(args.TableArn).ApplyT(func(arns []interface{}) string {
		arn := arns[0].(string)
		return fmt.Sprintf(`{
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Action": [
                        "dynamodb:GetItem",
                        "dynamodb:Query",
                        "dynamodb:Scan",
                        "dynamodb:BatchGetItem"
                    ],
                    "Resource": "%s"
                }
            ]
        }`, arn)
	}).(pulumi.StringOutput)

	_, err := iam.NewRolePolicy(ctx, name, &iam.RolePolicyArgs{
		Name:   policyName(ctx, name, args.Region),
		Role:   args.Role.Name,
		Policy: policyDoc,
	})
	return err
}

func AttachLambdaLoggingPolicy(ctx *pulumi.Context, name string, args LambdaLoggingPolicyArgs) error {
	_, err := iam.NewRolePolicyAttachment(ctx, name, &iam.RolePolicyAttachmentArgs{
		Role:      args.Role.Name,
		PolicyArn: pulumi.String("arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"),
	})
	return err
}

func policyName(ctx *pulumi.Context, name string, region string) pulumi.StringOutput {
	return pulumi.Sprintf("%s-%s-%s-%s", name, ctx.Project(), ctx.Stack(), region)
}
