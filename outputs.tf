# ==============================================================================
# Harness Infrastructure Resources - Outputs
# ==============================================================================

output "service_id" {
  description = "The ID of the Harness Service"
  value       = module.shopkart_service.id
}

output "service_identifier" {
  description = "The unique identifier of the Harness Service"
  value       = module.shopkart_service.identifier
}

output "pipeline_id" {
  description = "The ID of the Harness Pipeline"
  value       = module.shopkart_pipeline.id
}

output "pipeline_identifier" {
  description = "The unique identifier of the Harness Pipeline"
  value       = module.shopkart_pipeline.identifier
}

output "input_set_id" {
  description = "The ID of the Harness Input Set"
  value       = module.shopkart_input_set.id
}

output "input_set_identifier" {
  description = "The unique identifier of the Harness Input Set"
  value       = module.shopkart_input_set.identifier
}

output "trigger_id" {
  description = "The ID of the Harness Trigger"
  value       = module.shopkart_trigger.id
}

output "trigger_identifier" {
  description = "The unique identifier of the Harness Trigger"
  value       = module.shopkart_trigger.identifier
}

# ==============================================================================
# Rendered Templates (Allows offline inspection without live cloud credentials)
# ==============================================================================

output "rendered_service_yaml" {
  description = "The fully rendered Service YAML submitted to Harness Platform"
  value       = local.service_yaml
}

output "rendered_pipeline_yaml" {
  description = "The fully rendered Pipeline YAML submitted to Harness Platform"
  value       = local.pipeline_yaml
}

output "rendered_input_set_yaml" {
  description = "The fully rendered Input Set YAML submitted to Harness Platform"
  value       = local.input_set_yaml
}

output "rendered_trigger_yaml" {
  description = "The fully rendered Trigger YAML submitted to Harness Platform"
  value       = local.trigger_yaml
}
