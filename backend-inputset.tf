# ==============================================================================
# Harness Input Set: Backend Deployment Runtime Parameter Set
# ==============================================================================
# Flow:
# tfvars -> variables.tf -> data.template_file -> inputset.yaml -> module.input-sets -> harness_platform_input_set

locals {
  backend_inputset_name       = "${var.app_name}-backend-inputset"
  backend_inputset_identifier = "${replace(var.app_name, "-", "_")}_backend_inputset"
}

# 1. Render Input Set YAML template using data.template_file
data "template_file" "backend_inputset_tmpl" {
  template = file("${path.module}/_template_input_set/backend-inputset/inputset.yaml")

  vars = {
    name                = local.backend_inputset_name
    identifier          = local.backend_inputset_identifier
    org_id              = var.org_id
    project_id          = var.project_id
    pipeline_identifier = module.backend_pipeline.identifier
    service_identifier  = module.backend_service.identifier
    environment         = var.environment
    artifact_tag        = var.artifact_tag
  }
}

# 2. Instantiate reusable input-sets module with rendered YAML
module "backend_inputset" {
  source = "./modules/input-sets"

  identifier  = local.backend_inputset_identifier
  name        = local.backend_inputset_name
  org_id      = var.org_id
  project_id  = var.project_id
  pipeline_id = module.backend_pipeline.identifier
  yaml_data   = data.template_file.backend_inputset_tmpl.rendered

  tags = [
    "environment:${var.environment}",
    "tier:backend",
    "managed_by:terraform",
    "application:${var.app_name}"
  ]

  depends_on = [module.backend_pipeline]
}
