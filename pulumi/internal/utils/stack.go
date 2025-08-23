package utils

import (
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func GetStackReference(ctx *pulumi.Context, name string) (*pulumi.StackReference, error) {
	qualifiedName := GetStackName(name, ctx)
	stackReference, err := pulumi.NewStackReference(ctx, qualifiedName, nil)
	if err != nil {
		return nil, err
	}
	return stackReference, nil
}
