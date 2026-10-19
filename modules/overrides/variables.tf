# ==============================================================================
# Harness Environment Service Overrides Module - Input Variables
# ==============================================================================

variable "org_id" {
  description = "Harness Organization identifier"
  type        = string
}

variable "project_id" {
  description = "Harness Project identifier"
  type        = string
}

variable "env_id" {
  description = "Environment identifier to which the service overrides apply"
  type        = string
}

variable "service_id" {
  description = "Service identifier to which the service overrides apply"
  type        = string
}

variable "yaml_data" {
  description = "Rendered YAML configuration specifying the environment service overrides"
  type        = string
}

variable "identifier" {
  description = "Optional unique identifier for the service overrides resource"
  type        = string
  default     = null
}
