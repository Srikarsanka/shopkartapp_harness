output "id" {
  description = "Unique ID of the created Harness Service"
  value       = harness_platform_service.this.id
}

output "identifier" {
  description = "Identifier of the created Harness Service"
  value       = harness_platform_service.this.identifier
}

output "name" {
  description = "Name of the created Harness Service"
  value       = harness_platform_service.this.name
}
