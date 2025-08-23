package main

import (
	"derma-practice/internal/utils"

	"github.com/pulumi/pulumi-aws/sdk/v7/go/aws/dynamodb"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func main() {
	pulumi.Run(func(ctx *pulumi.Context) error {
		region, err := utils.GetAWSRegion(ctx)
		if err != nil {
			return err
		}

		table, err := createDynamoDBTable(ctx, region)
		if err != nil {
			return err
		}

		ctx.Export("tableArn", table.Arn)
		ctx.Export("tableName", table.Name)
		return nil
	})
}

func createDynamoDBTable(ctx *pulumi.Context, region string) (*dynamodb.Table, error) {
	tableName := pulumi.Sprintf("%s-%s-%s", ctx.Project(), ctx.Stack(), region)
	table, err := dynamodb.NewTable(ctx, ctx.Project(), &dynamodb.TableArgs{
		Name:        tableName,
		BillingMode: pulumi.String("PAY_PER_REQUEST"),
		HashKey:     pulumi.String("id"),
		Attributes: dynamodb.TableAttributeArray{
			&dynamodb.TableAttributeArgs{
				Name: pulumi.String("id"),
				Type: pulumi.String("S"),
			},
		},
		PointInTimeRecovery: &dynamodb.TablePointInTimeRecoveryArgs{
			Enabled: pulumi.Bool(true),
		},
	})

	if err != nil {
		return nil, err
	}

	return table, nil
}
