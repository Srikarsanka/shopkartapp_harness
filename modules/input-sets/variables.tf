variable "identifier" {
  description = "Unique identifier of the Harness Input Set"
  type        = string
}

variable "name" {
  description = "Display name of the Harness Input Set"
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

variable "pipeline_id" {
  description = "Target Pipeline identifier to which this Input Set belongs"
  type        = string
}

variable "yaml_data" {
  description = "Rendered YAML definition of the Harness Input Set"
  type        = string
}

variable "tags" {
  description = "Tags to associate with the Harness Input Set"
  type        = list(string)
  default     = ["managed_by:terraform", "app:shopkart"]
}
