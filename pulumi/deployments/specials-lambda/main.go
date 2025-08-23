package main

import (
	"derma-practice/internal/infrastructure/iam"
	"derma-practice/internal/infrastructure/lambda"
	"derma-practice/internal/utils"

	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi/config"
)

func main() {
	pulumi.Run(func(ctx *pulumi.Context) error {
		region, err := utils.GetAWSRegion(ctx)
		if err != nil {
			return err
		}

		config := config.New(ctx, "")
		artefactsBucket := config.Require("artefactsBucket")

		storeStack, err := utils.GetStackReference(ctx, "specials-store")
		if err != nil {
			return err
		}

		tableName := storeStack.GetStringOutput(pulumi.String("tableName"))
		lambda, err := createLambda(ctx, region, artefactsBucket, tableName)
		if err != nil {
			return err
		}

		err = iam.AttachDynamoDBReadPolicy(ctx, "specials-lambda-dynamo-access", iam.DynamoDBReadPolicyArgs{
			Role:     lambda.Role,
			TableArn: storeStack.GetStringOutput(pulumi.String("tableArn")),
		})
		if err != nil {
			return err
		}

		err = iam.AttachLambdaLoggingPolicy(ctx, "specials-lambda-logging", iam.LambdaLoggingPolicyArgs{
			Role:   lambda.Role,
			Region: region,
		})
		if err != nil {
			return err
		}

		return nil
	})
}

func createLambda(ctx *pulumi.Context, region, artefactsBucket string, tableName pulumi.StringOutput) (*lambda.GoLambdaFunction, error) {
	lambda, err := lambda.NewGoLambdaFunction(
		"specials-handler",
		ctx,
		lambda.GoLambdaArgs{
			S3Bucket: artefactsBucket,
			S3Key:    "go-specials-handler.zip",
			Region:   region,
			Environment: pulumi.StringMap{
				"SPECIALS_TABLE_NAME": tableName,
			},
		},
	)
	if err != nil {
		return nil, err
	}
	ctx.Export("lambdaArn", lambda.Arn)
	ctx.Export("lambdaName", lambda.Name)
	return lambda, nil
}
