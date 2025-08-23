package iam

import (
	"github.com/pulumi/pulumi-aws/sdk/v7/go/aws/iam"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

type LambdaExecutionRoleArgs struct {
	RoleName pulumi.StringInput
}

type LambdaExecutionRole struct {
	pulumi.ResourceState
	Role *iam.Role
	Arn  pulumi.StringOutput
}

func NewLambdaExecutionRole(ctx *pulumi.Context, name string, args LambdaExecutionRoleArgs) (*LambdaExecutionRole, error) {
	component := &LambdaExecutionRole{}
	err := ctx.RegisterComponentResource("custom:iam:LambdaExecutionRole", name, component)
	if err != nil {
		return nil, err
	}
	role, err := component.createLambdaRole(ctx, name, args)
	if err != nil {
		return nil, err
	}
	component.Role = role
	component.Arn = role.Arn
	return component, nil
}

func (l *LambdaExecutionRole) createLambdaRole(ctx *pulumi.Context, name string, args LambdaExecutionRoleArgs) (*iam.Role, error) {
	role, err := iam.NewRole(ctx, name, &iam.RoleArgs{
		Name: args.RoleName,
		AssumeRolePolicy: pulumi.String(`{
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Action": "sts:AssumeRole",
                    "Principal": {
                        "Service": "lambda.amazonaws.com"
                    },
                    "Effect": "Allow"
                }
            ]
        }`),
	}, pulumi.Parent(l))

	if err != nil {
		return nil, err
	}
	return role, nil
}
