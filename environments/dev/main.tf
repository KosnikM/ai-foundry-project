resource "azurerm_resource_group" "networking" {
  name     = "rg-networking"
  location = local.location
  tags     = local.default_tags
}

resource "azurerm_resource_group" "security" {
  name     = "rg-security"
  location = local.location
  tags     = local.default_tags
}

resource "azurerm_resource_group" "compute" {
  name     = "rg-compute"
  location = local.location
  tags     = local.default_tags
}

resource "azurerm_resource_group" "monitoring" {
  name     = "rg-monitoring"
  location = local.location
  tags     = local.default_tags
}

resource "azurerm_resource_group" "governance" {
  name     = "rg-governance"
  location = local.location
  tags     = local.default_tags
}

resource "azurerm_resource_group" "ai" {
  name     = "rg-ai"
  location = "swedencentral"
  tags     = local.default_tags
}

module "networking" {
  source              = "../../modules/networking"
  resource_group_name = azurerm_resource_group.networking.name
  location            = local.location
  tags                = local.default_tags
  vnets = {
    hub = {
      address_space = ["10.0.0.0/16"]
      subnets = {
        AzureFirewallSubnet = { 
          address_prefix = "10.0.1.0/26"
          nsg_rules = [] 
        }
        AzureBastionSubnet = {
          address_prefix = "10.0.2.0/26"
          nsg_rules = [
            {
              name                       = "allow-https-inbound"
              priority                   = 100
              direction                  = "Inbound"
              access                     = "Allow"
              protocol                   = "Tcp"
              source_port_range          = "*"
              destination_port_range     = "443"
              source_address_prefix      = "Internet"
              destination_address_prefix = "*"
            },
            {
              name                       = "allow-gateway-manager"
              priority                   = 110
              direction                  = "Inbound"
              access                     = "Allow"
              protocol                   = "Tcp"
              source_port_range          = "*"
              destination_port_range     = "443"
              source_address_prefix      = "GatewayManager"
              destination_address_prefix = "*"
            },
            {
              name                       = "allow-azure-load-balancer"
              priority                   = 120
              direction                  = "Inbound"
              access                     = "Allow"
              protocol                   = "Tcp"
              source_port_range          = "*"
              destination_port_range     = "443"
              source_address_prefix      = "AzureLoadBalancer"
              destination_address_prefix = "*"
            },
            {
              name                       = "allow-bastion-communication-5701"
              priority                   = 131
              direction                  = "Inbound"
              access                     = "Allow"
              protocol                   = "*"
              source_port_range          = "*"
              destination_port_range     = "5701"
              source_address_prefix      = "VirtualNetwork"
              destination_address_prefix = "VirtualNetwork"
            },
            {
              name                       = "allow-bastion-communication-8080"
              priority                   = 130
              direction                  = "Inbound"
              access                     = "Allow"
              protocol                   = "*"
              source_port_range          = "*"
              destination_port_range     = "8080"
              source_address_prefix      = "VirtualNetwork"
              destination_address_prefix = "VirtualNetwork"
            },
            {
              name                       = "deny-all-inbound"
              priority                   = 4096
              direction                  = "Inbound"
              access                     = "Deny"
              protocol                   = "*"
              source_port_range          = "*"
              destination_port_range     = "*"
              source_address_prefix      = "*"
              destination_address_prefix = "*"
            },
            {
              name                       = "allow-https-outbound"
              priority                   = 100
              direction                  = "Outbound"
              access                     = "Allow"
              protocol                   = "Tcp"
              source_port_range          = "*"
              destination_port_range     = "443"
              source_address_prefix      = "*"
              destination_address_prefix = "Internet"
            },
            {
              name                       = "allow-ssh-rdp-outbound-22"
              priority                   = 110
              direction                  = "Outbound"
              access                     = "Allow"
              protocol                   = "*"
              source_port_range          = "*"
              destination_port_range     = "22"
              source_address_prefix      = "*"
              destination_address_prefix = "VirtualNetwork"
            },
            {
              name                       = "allow-ssh-rdp-outbound-3389"
              priority                   = 111
              direction                  = "Outbound"
              access                     = "Allow"
              protocol                   = "*"
              source_port_range          = "*"
              destination_port_range     = "3389"
              source_address_prefix      = "*"
              destination_address_prefix = "VirtualNetwork"
            },
            {
              name                       = "allow-azure-cloud-outbound"
              priority                   = 120
              direction                  = "Outbound"
              access                     = "Allow"
              protocol                   = "Tcp"
              source_port_range          = "*"
              destination_port_range     = "443"
              source_address_prefix      = "*"
              destination_address_prefix = "AzureCloud"
            },
            {
              name                       = "allow-bastion-communication-outbound-8080"
              priority                   = 130
              direction                  = "Outbound"
              access                     = "Allow"
              protocol                   = "*"
              source_port_range          = "*"
              destination_port_range     = "8080"
              source_address_prefix      = "VirtualNetwork"
              destination_address_prefix = "VirtualNetwork"
            },
              {
              name                       = "allow-bastion-communication-outbound-5701"
              priority                   = 131
              direction                  = "Outbound"
              access                     = "Allow"
              protocol                   = "*"
              source_port_range          = "*"
              destination_port_range     = "5701"
              source_address_prefix      = "VirtualNetwork"
              destination_address_prefix = "VirtualNetwork"
            }
        ] }
        snet-jumpbox = { address_prefix = "10.0.3.0/29"
          nsg_rules = [{
            name                       = "allow-rdp-from-bastion"
            priority                   = 100
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "Tcp"
            source_port_range          = "*"
            destination_port_range     = "3389"
            source_address_prefix      = "10.0.2.0/26"
            destination_address_prefix = "*"
            },
            {
              name                       = "deny-all-inbound"
              priority                   = 4096
              direction                  = "Inbound"
              access                     = "Deny"
              protocol                   = "*"
              source_port_range          = "*"
              destination_port_range     = "*"
              source_address_prefix      = "*"
              destination_address_prefix = "*"
          }]

        }
      }

    }
    spoke = {
      address_space = ["10.1.0.0/16"]
      subnets = {
        snet-appgw = {
          address_prefix = "10.1.1.0/24"
          nsg_rules = [
            {
              name                       = "allow-https-inbound"
              priority                   = 100
              direction                  = "Inbound"
              access                     = "Allow"
              protocol                   = "Tcp"
              source_port_range          = "*"
              destination_port_range     = "443"
              source_address_prefix      = "*"
              destination_address_prefix = "*"
            },
            {
              name                       = "allow-appgw-health-probe"
              priority                   = 110
              direction                  = "Inbound"
              access                     = "Allow"
              protocol                   = "Tcp"
              source_port_range          = "*"
              destination_port_range     = "65200-65535"
              source_address_prefix      = "GatewayManager"
              destination_address_prefix = "*"
            },
            {
              name                       = "deny-all-inbound"
              priority                   = 4096
              direction                  = "Inbound"
              access                     = "Deny"
              protocol                   = "*"
              source_port_range          = "*"
              destination_port_range     = "*"
              source_address_prefix      = "*"
              destination_address_prefix = "*"
            }
          ]
        }
        snet-app = {
          address_prefix = "10.1.2.0/24"
          nsg_rules = [
            {
              name                       = "allow-from-appgw"
              priority                   = 100
              direction                  = "Inbound"
              access                     = "Allow"
              protocol                   = "Tcp"
              source_port_range          = "*"
              destination_port_range     = "443"
              source_address_prefix      = "10.1.1.0/24"
              destination_address_prefix = "*"
            },
            {
              name                       = "deny-all-inbound"
              priority                   = 4096
              direction                  = "Inbound"
              access                     = "Deny"
              protocol                   = "*"
              source_port_range          = "*"
              destination_port_range     = "*"
              source_address_prefix      = "*"
              destination_address_prefix = "*"
            }
          ]
        }
        snet-pe = {
          address_prefix = "10.1.3.0/24"
          nsg_rules = [
            {
              name                       = "deny-all-inbound"
              priority                   = 4096
              direction                  = "Inbound"
              access                     = "Deny"
              protocol                   = "*"
              source_port_range          = "*"
              destination_port_range     = "*"
              source_address_prefix      = "*"
              destination_address_prefix = "*"
            }
          ]
        }
      }
    }
    ai = {
      address_space = ["10.2.0.0/16"]
      subnets = {
        snet-ai = {
          address_prefix = "10.2.1.0/24"
          nsg_rules = [
            {
              name                       = "deny-all-inbound"
              priority                   = 4096
              direction                  = "Inbound"
              access                     = "Deny"
              protocol                   = "*"
              source_port_range          = "*"
              destination_port_range     = "*"
              source_address_prefix      = "*"
              destination_address_prefix = "*"
            }
          ]
        }
      }
    }
  }
  private_dns_zones = [
    "privatelink.openai.azure.com",
    "privatelink.vaultcore.azure.net",
    "privatelink.blob.core.windows.net",
    "privatelink.azurewebsites.net",
    "privatelink.azurecr.io",
    "privatelink.azmk8s.io",
    "privatelink.search.azure.com",
    "privatelink.monitor.azure.com",
    "privatelink.azure-api.net"
  ]
}