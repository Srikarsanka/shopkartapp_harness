# ==============================================================================
# Harness Trigger: Frontend Webhook Git Trigger Definition
# ==============================================================================
# Flow:
# tfvars -> variables.tf -> data.template_file -> trigger.yaml -> module.triggers -> harness_platform_triggers

locals {
  frontend_trigger_name       = "${var.app_name}-frontend-trigger"
  frontend_trigger_identifier = "${replace(var.app_name, "-", "_")}_frontend_trigger"
}

# 1. Render Trigger YAML template using data.template_file
data "template_file" "frontend_trigger_tmpl" {
  template = file("${path.module}/_template_trigger/frontend-trigger/trigger.yaml")

  vars = {
    name                = local.frontend_trigger_name
    identifier          = local.frontend_trigger_identifier
    org_id              = var.org_id
    project_id          = var.project_id
    pipeline_identifier = module.frontend_pipeline.identifier
    connector_ref       = var.git_connector_ref
    repo_name           = var.git_repo_name
    branch              = var.git_branch
    environment         = var.environment
  }
}

# 2. Instantiate reusable triggers module with rendered YAML
module "frontend_trigger" {
  source = "./modules/triggers"

  identifier = local.frontend_trigger_identifier
  name       = local.frontend_trigger_name
  org_id     = var.org_id
  project_id = var.project_id
  target_id  = module.frontend_pipeline.identifier
  yaml_data  = data.template_file.frontend_trigger_tmpl.rendered

  tags = [
    "environment:${var.environment}",
    "tier:frontend",
    "managed_by:terraform",
    "application:${var.app_name}"
  ]

  depends_on = [module.frontend_pipeline]
}
