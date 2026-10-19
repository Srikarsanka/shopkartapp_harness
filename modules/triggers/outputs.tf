output "id" {
  description = "Unique ID of the created Harness Trigger"
  value       = harness_platform_triggers.this.id
}

output "identifier" {
  description = "Identifier of the created Harness Trigger"
  value       = harness_platform_triggers.this.identifier
}

output "name" {
  description = "Name of the created Harness Trigger"
  value       = harness_platform_triggers.this.name
}
