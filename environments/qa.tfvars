# ==============================================================================
# QA / Staging Environment Configuration (environments/qa.tfvars)
# ==============================================================================
# Context: Pre-production QA environment for integration testing and verification.
# High availability enabled with multiple replicas and moderate resource limits.

harness_endpoint         = "https://app.harness.io/gateway"
harness_account_id       = "demo_harness_account_22"
harness_platform_api_key = "pat.dummy_token_do_not_use_in_production"

org_id     = "default"
project_id = "shopkart_qa_project"

environment = "qa"
app_name    = "shopkart"

# Connector references configured in Harness Account / Org level
git_connector_ref    = "account.github_shopkart_connector"
git_repo_name        = "shopkart-app"
git_branch           = "release/qa"
docker_connector_ref = "account.docker_hub_connector"
k8s_connector_ref    = "account.kubernetes_qa_cluster"

# Image and target Kubernetes identifiers
backend_image_repo          = "ghcr.io/example-user/shopkart-backend"
frontend_image_repo         = "ghcr.io/example-user/shopkart-frontend"
build_namespace             = "harness-build"
environment_identifier      = "shopkart_qa_env"
infra_definition_identifier = "shopkart_k8s_qa_infra"
artifact_tag                = "v1.0.0-rc1"

# Service Overrides & Resource Sizing for QA
backend_replica_count  = 2
frontend_replica_count = 2
backend_memory_limit   = "512Mi"
backend_cpu_limit      = "500m"
frontend_memory_limit  = "256Mi"
frontend_cpu_limit     = "250m"
backend_log_level      = "info"
mongodb_uri            = "mongodb://qa-mongodb.database.svc.cluster.local:27017/shopkart_qa"
api_gateway_url        = "https://qa.shopkart.internal/api"
