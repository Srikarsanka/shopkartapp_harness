variable "identifier" {
  description = "Unique identifier of the Harness Trigger"
  type        = string
}

variable "name" {
  description = "Display name of the Harness Trigger"
  type        = string
}

variable "org_id" {
  description = "Harness Organization identifier"
  type        = string
}

variable "project_id" {
  description = "Harness Project identifier"
  type        = string
}

variable "target_id" {
  description = "Target Pipeline identifier to trigger"
  type        = string
}

variable "yaml_data" {
  description = "Rendered YAML definition of the Harness Trigger"
  type        = string
}

variable "tags" {
  description = "Tags to associate with the Harness Trigger"
  type        = list(string)
  default     = ["managed_by:terraform", "app:shopkart"]
}
