# ==============================================================================
# Fictional Development Environment Settings (env_dev.tfvars)
# ==============================================================================
# NOTE: Never store real secrets or API keys in this file.
# Supply real secrets via HARNESS_PLATFORM_API_KEY environment variable.

harness_endpoint         = "https://app.harness.io/gateway"
harness_account_id       = "demo_harness_account_22"
harness_platform_api_key = "pat.dummy_token_do_not_use_in_production"

org_id     = "default"
project_id = "shopkart_dev_project"

environment = "dev"
app_name    = "shopkart"

# Connector references configured in Harness Account/Project Connectors
git_connector_ref    = "account.github_shopkart_connector"
git_repo_name        = "shopkart-app"
git_branch           = "main"
docker_connector_ref = "account.docker_hub_connector"
k8s_connector_ref    = "account.kubernetes_dev_cluster"

# Image and target Kubernetes identifiers
backend_image_repo          = "ghcr.io/example-user/shopkart-backend"
frontend_image_repo         = "ghcr.io/example-user/shopkart-frontend"
build_namespace             = "harness-build"
environment_identifier      = "shopkart_dev_env"
infra_definition_identifier = "shopkart_k8s_dev_infra"
artifact_tag                = "v1.0.0-dev"
