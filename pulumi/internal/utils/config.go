package utils

import (
	"github.com/pulumi/pulumi-aws/sdk/v7/go/aws"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func GetAWSRegion(ctx *pulumi.Context) (string, error) {
	awsRegion, err := aws.GetRegion(ctx, nil, nil)
	if err != nil {
		return "", err
	}
	return awsRegion.Region, nil
}
