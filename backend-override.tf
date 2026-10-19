# ==============================================================================
# Harness Service Override: Backend Environment-Specific Tuning
# ==============================================================================
# Flow:
# tfvars -> variables.tf -> data.template_file -> override.yaml -> module.overrides -> harness_platform_environment_service_overrides

locals {
  backend_override_identifier = "${replace(var.app_name, "-", "_")}_backend_override_${var.environment}"
}

# 1. Render Override YAML template using data.template_file
data "template_file" "backend_override_tmpl" {
  template = file("${path.module}/_template_override/shopkart-override/override.yaml")

  vars = {
    environment_identifier = var.environment_identifier
    service_identifier     = module.backend_service.identifier
    replica_count          = var.backend_replica_count
    memory_limit           = var.backend_memory_limit
    cpu_limit              = var.backend_cpu_limit
    log_level              = var.backend_log_level
    config_endpoint        = var.mongodb_uri
  }
}

# 2. Instantiate reusable overrides module with rendered YAML
module "backend_override" {
  source = "./modules/overrides"

  identifier = local.backend_override_identifier
  org_id     = var.org_id
  project_id = var.project_id
  env_id     = var.environment_identifier
  service_id = module.backend_service.identifier
  yaml_data  = data.template_file.backend_override_tmpl.rendered

  depends_on = [module.backend_service]
}
