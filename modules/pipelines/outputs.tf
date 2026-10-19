output "id" {
  description = "Unique ID of the created Harness Pipeline"
  value       = harness_platform_pipeline.this.id
}

output "identifier" {
  description = "Identifier of the created Harness Pipeline"
  value       = harness_platform_pipeline.this.identifier
}

output "name" {
  description = "Name of the created Harness Pipeline"
  value       = harness_platform_pipeline.this.name
}
