# ==============================================================================
# Development Environment Configuration (environments/dev.tfvars)
# ==============================================================================
# Context: Non-production development environment for rapid developer feedback.
# Replicas are kept low, log levels set to debug, and fast iteration enabled.

harness_endpoint         = "https://app.harness.io/gateway"
harness_account_id       = "demo_harness_account_22"
harness_platform_api_key = "pat.dummy_token_do_not_use_in_production"

org_id     = "default"
project_id = "shopkart_dev_project"

environment = "dev"
app_name    = "shopkart"

# Connector references configured in Harness Account / Org level
git_connector_ref    = "account.github_shopkart_connector"
git_repo_name        = "shopkart-app"
git_branch           = "develop"
docker_connector_ref = "account.docker_hub_connector"
k8s_connector_ref    = "account.kubernetes_dev_cluster"

# Image and target Kubernetes identifiers
backend_image_repo          = "ghcr.io/example-user/shopkart-backend"
frontend_image_repo         = "ghcr.io/example-user/shopkart-frontend"
build_namespace             = "harness-build"
environment_identifier      = "shopkart_dev_env"
infra_definition_identifier = "shopkart_k8s_dev_infra"
artifact_tag                = "dev-latest"

# Service Overrides & Resource Sizing for Dev
backend_replica_count  = 1
frontend_replica_count = 1
backend_memory_limit   = "256Mi"
backend_cpu_limit      = "250m"
frontend_memory_limit  = "128Mi"
frontend_cpu_limit     = "150m"
backend_log_level      = "debug"
mongodb_uri            = "mongodb://dev-mongodb.database.svc.cluster.local:27017/shopkart_dev"
api_gateway_url        = "http://dev.shopkart.internal/api"
