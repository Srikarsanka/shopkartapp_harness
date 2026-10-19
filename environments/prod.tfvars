# ==============================================================================
# Production Environment Configuration (environments/prod.tfvars)
# ==============================================================================
# Context: Mission-critical live production environment.
# Strictly controlled: semver tags only, production clusters, high availability,
# strict resource allocations, and minimal log verbosity.

harness_endpoint         = "https://app.harness.io/gateway"
harness_account_id       = "demo_harness_account_22"
harness_platform_api_key = "pat.dummy_token_do_not_use_in_production"

org_id     = "default"
project_id = "shopkart_prod_project"

environment = "prod"
app_name    = "shopkart"

# Connector references configured in Harness Account / Org level
git_connector_ref    = "account.github_shopkart_connector"
git_repo_name        = "shopkart-app"
git_branch           = "main"
docker_connector_ref = "account.docker_hub_connector"
k8s_connector_ref    = "account.kubernetes_prod_cluster"

# Image and target Kubernetes identifiers
backend_image_repo          = "ghcr.io/example-user/shopkart-backend"
frontend_image_repo         = "ghcr.io/example-user/shopkart-frontend"
build_namespace             = "harness-build"
environment_identifier      = "shopkart_prod_env"
infra_definition_identifier = "shopkart_k8s_prod_infra"
artifact_tag                = "v1.0.0"

# Service Overrides & Resource Sizing for Production
backend_replica_count  = 4
frontend_replica_count = 3
backend_memory_limit   = "1Gi"
backend_cpu_limit      = "1000m"
frontend_memory_limit  = "512Mi"
frontend_cpu_limit     = "500m"
backend_log_level      = "warn"
mongodb_uri            = "mongodb+srv://prod-admin:SECURE_VAULT_REF@shopkart-prod.mongodb.net/shopkart"
api_gateway_url        = "https://api.shopkart.com/api"
