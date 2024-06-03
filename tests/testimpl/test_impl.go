package common

import (
	"context"
	"os"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/network/armnetwork/v5"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
)

func TestFirewall(t *testing.T, ctx types.TestContext) {

	subscriptionID := os.Getenv("ARM_SUBSCRIPTION_ID")
	if len(subscriptionID) == 0 {
		t.Fatal("ARM_SUBSCRIPTION_ID is not set in the environment variables ")
	}

	cred, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil {
		t.Fatalf("Unable to get credentials: %e\n", err)
	}

	clientFactory, err := armnetwork.NewClientFactory(subscriptionID, cred, nil)
	if err != nil {
		t.Fatalf("Unable to get clientFactory: %e\n", err)
	}

	firewallsClient := clientFactory.NewAzureFirewallsClient()

	t.Run("doesFirewallExist", func(t *testing.T) {
		firewallId := terraform.Output(t, ctx.TerratestTerraformOptions(), "firewall_id")
		firewallName := terraform.Output(t, ctx.TerratestTerraformOptions(), "firewall_name")
		resourceGroupName := terraform.Output(t, ctx.TerratestTerraformOptions(), "resource_group_name")

		firewall, err := firewallsClient.Get(context.Background(), resourceGroupName, firewallName, nil)
		if err != nil {
			t.Fatalf("Error getting firewall: %v", err)
		}

		assert.Equal(t, *firewall.ID, firewallId, "Expected ID did not match actual ID!")
		assert.Equal(t, *firewall.Name, firewallName, "Expected Name did not match actual Name!")
	})
}
