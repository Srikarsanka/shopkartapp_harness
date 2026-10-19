# ==============================================================================
# Template Rendering Module - Input Variables (variables.tf)
# ==============================================================================

variable "template_path" {
  description = "File path to the template YAML file"
  type        = string
}

variable "template_vars" {
  description = "Map of variable names and values to interpolate into the template"
  type        = map(any)
  default     = {}
}
