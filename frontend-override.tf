# ==============================================================================
# Harness Service Override: Frontend Environment-Specific Tuning
# ==============================================================================
# Flow:
# tfvars -> variables.tf -> data.template_file -> override.yaml -> module.overrides -> harness_platform_environment_service_overrides

locals {
  frontend_override_identifier = "${replace(var.app_name, "-", "_")}_frontend_override_${var.environment}"
}

# 1. Render Override YAML template using data.template_file
data "template_file" "frontend_override_tmpl" {
  template = file("${path.module}/_template_override/shopkart-override/override.yaml")

  vars = {
    environment_identifier = var.environment_identifier
    service_identifier     = module.frontend_service.identifier
    replica_count          = var.frontend_replica_count
    memory_limit           = var.frontend_memory_limit
    cpu_limit              = var.frontend_cpu_limit
    log_level              = "info"
    config_endpoint        = var.api_gateway_url
  }
}

# 2. Instantiate reusable overrides module with rendered YAML
module "frontend_override" {
  source = "./modules/overrides"

  identifier = local.frontend_override_identifier
  org_id     = var.org_id
  project_id = var.project_id
  env_id     = var.environment_identifier
  service_id = module.frontend_service.identifier
  yaml_data  = data.template_file.frontend_override_tmpl.rendered

  depends_on = [module.frontend_service]
}
