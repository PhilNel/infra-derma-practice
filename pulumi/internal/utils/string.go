package utils

import (
	"fmt"

	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func GetStackName(name string, ctx *pulumi.Context) string {
	return fmt.Sprintf("%s/%s/%s", ctx.Organization(), name, ctx.Stack())
}
