locals {
  environment = "dev"
  project     = "bank-ai-infra"
  location    = "polandcentral"
  owner       = "maciek"

  default_tags = {
    environment = local.environment
    project     = local.project
    owner       = local.owner
    cost-center = "IT-CloudOps"
    managed-by  = "terraform"
  }
}