# ==============================================================================
# Harness Input Set Module - Resource Definition (inputsets.tf)
# ==============================================================================

resource "harness_platform_input_set" "this" {
  identifier  = var.identifier
  name        = var.name
  org_id      = var.org_id
  project_id  = var.project_id
  pipeline_id = var.pipeline_id
  yaml        = var.yaml_data
  tags        = var.tags
}
