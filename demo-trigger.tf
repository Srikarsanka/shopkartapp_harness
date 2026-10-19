# ==============================================================================
# Harness Trigger: Webhook Trigger for ShopKart Pipeline
# ==============================================================================

locals {
  trigger_name       = "${var.app_name}-git-push-trigger"
  trigger_identifier = "${replace(var.app_name, "-", "_")}_git_push_trigger"

  # Render YAML definition using Terraform templatefile
  trigger_yaml = templatefile("${path.module}/_template_trigger/shopkart-trigger/trigger.yaml", {
    name                 = local.trigger_name
    identifier           = local.trigger_identifier
    org_id               = var.org_id
    project_id           = var.project_id
    target_id            = module.shopkart_pipeline.identifier
    connector_ref        = var.git_connector_ref
    repo_name            = var.git_repo_name
    target_branch        = var.git_branch
    trigger_action       = "push"
    input_set_identifier = module.shopkart_input_set.identifier
  })
}

module "shopkart_trigger" {
  source = "./modules/triggers"

  identifier = local.trigger_identifier
  name       = local.trigger_name
  org_id     = var.org_id
  project_id = var.project_id
  target_id  = module.shopkart_pipeline.identifier
  yaml_data  = local.trigger_yaml

  tags = [
    "environment:${var.environment}",
    "managed_by:terraform",
    "application:${var.app_name}"
  ]

  depends_on = [
    module.shopkart_pipeline,
    module.shopkart_input_set
  ]
}
