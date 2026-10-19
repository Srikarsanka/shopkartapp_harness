# ==============================================================================
# Harness Input Set: Frontend Deployment Runtime Parameter Set
# ==============================================================================
# Flow:
# tfvars -> variables.tf -> data.template_file -> inputset.yaml -> module.input-sets -> harness_platform_input_set

locals {
  frontend_inputset_name       = "${var.app_name}-frontend-inputset"
  frontend_inputset_identifier = "${replace(var.app_name, "-", "_")}_frontend_inputset"
}

# 1. Render Input Set YAML template using data.template_file
data "template_file" "frontend_inputset_tmpl" {
  template = file("${path.module}/_template_input_set/frontend-inputset/inputset.yaml")

  vars = {
    name                = local.frontend_inputset_name
    identifier          = local.frontend_inputset_identifier
    org_id              = var.org_id
    project_id          = var.project_id
    pipeline_identifier = module.frontend_pipeline.identifier
    service_identifier  = module.frontend_service.identifier
    environment         = var.environment
    artifact_tag        = var.artifact_tag
  }
}

# 2. Instantiate reusable input-sets module with rendered YAML
module "frontend_inputset" {
  source = "./modules/input-sets"

  identifier  = local.frontend_inputset_identifier
  name        = local.frontend_inputset_name
  org_id      = var.org_id
  project_id  = var.project_id
  pipeline_id = module.frontend_pipeline.identifier
  yaml_data   = data.template_file.frontend_inputset_tmpl.rendered

  tags = [
    "environment:${var.environment}",
    "tier:frontend",
    "managed_by:terraform",
    "application:${var.app_name}"
  ]

  depends_on = [module.frontend_pipeline]
}
