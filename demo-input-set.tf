# ==============================================================================
# Harness Input Set: Runtime Parameters for ShopKart Pipeline
# ==============================================================================

locals {
  input_set_name       = "${var.app_name}-dev-input-set"
  input_set_identifier = "${replace(var.app_name, "-", "_")}_dev_input_set"

  # Render YAML definition using Terraform templatefile
  input_set_yaml = templatefile("${path.module}/_template_input_set/shopkart-input-set/inputset.yaml", {
    name                = local.input_set_name
    identifier          = local.input_set_identifier
    org_id              = var.org_id
    project_id          = var.project_id
    pipeline_identifier = module.shopkart_pipeline.identifier
    artifact_tag        = var.artifact_tag
    environment         = var.environment
  })
}

module "shopkart_input_set" {
  source = "./modules/input-sets"

  identifier  = local.input_set_identifier
  name        = local.input_set_name
  org_id      = var.org_id
  project_id  = var.project_id
  pipeline_id = module.shopkart_pipeline.identifier
  yaml_data   = local.input_set_yaml

  tags = [
    "environment:${var.environment}",
    "managed_by:terraform",
    "application:${var.app_name}"
  ]

  depends_on = [
    module.shopkart_pipeline
  ]
}
