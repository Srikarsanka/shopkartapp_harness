# ==============================================================================
# Harness Infrastructure Resources - Outputs (outputs.tf)
# ==============================================================================

# ------------------------------------------------------------------------------
# Frontend Microservice Outputs
# ------------------------------------------------------------------------------

output "frontend_service_id" {
  description = "The ID of the Frontend Harness Service"
  value       = module.frontend_service.id
}

output "frontend_service_identifier" {
  description = "The unique identifier of the Frontend Harness Service"
  value       = module.frontend_service.identifier
}

output "frontend_pipeline_id" {
  description = "The ID of the Frontend Harness Pipeline"
  value       = module.frontend_pipeline.id
}

output "frontend_pipeline_identifier" {
  description = "The unique identifier of the Frontend Harness Pipeline"
  value       = module.frontend_pipeline.identifier
}

output "frontend_inputset_id" {
  description = "The ID of the Frontend Harness Input Set"
  value       = module.frontend_inputset.id
}

output "frontend_trigger_id" {
  description = "The ID of the Frontend Harness Trigger"
  value       = module.frontend_trigger.id
}

output "frontend_override_id" {
  description = "The ID of the Frontend Harness Environment Service Override"
  value       = module.frontend_override.id
}

# ------------------------------------------------------------------------------
# Backend Microservice Outputs
# ------------------------------------------------------------------------------

output "backend_service_id" {
  description = "The ID of the Backend Harness Service"
  value       = module.backend_service.id
}

output "backend_service_identifier" {
  description = "The unique identifier of the Backend Harness Service"
  value       = module.backend_service.identifier
}

output "backend_pipeline_id" {
  description = "The ID of the Backend Harness Pipeline"
  value       = module.backend_pipeline.id
}

output "backend_pipeline_identifier" {
  description = "The unique identifier of the Backend Harness Pipeline"
  value       = module.backend_pipeline.identifier
}

output "backend_inputset_id" {
  description = "The ID of the Backend Harness Input Set"
  value       = module.backend_inputset.id
}

output "backend_trigger_id" {
  description = "The ID of the Backend Harness Trigger"
  value       = module.backend_trigger.id
}

output "backend_override_id" {
  description = "The ID of the Backend Harness Environment Service Override"
  value       = module.backend_override.id
}

# ------------------------------------------------------------------------------
# Rendered YAML Outputs (Enables offline inspection of the data flow)
# ------------------------------------------------------------------------------

output "frontend_service_rendered_yaml" {
  description = "Rendered YAML for Frontend Service"
  value       = data.template_file.frontend_service_tmpl.rendered
}

output "backend_service_rendered_yaml" {
  description = "Rendered YAML for Backend Service"
  value       = data.template_file.backend_service_tmpl.rendered
}

output "frontend_pipeline_rendered_yaml" {
  description = "Rendered YAML for Frontend Pipeline"
  value       = data.template_file.frontend_pipeline_tmpl.rendered
}

output "backend_pipeline_rendered_yaml" {
  description = "Rendered YAML for Backend Pipeline"
  value       = data.template_file.backend_pipeline_tmpl.rendered
}
