# ==============================================================================
# Template Rendering Module - Resource/Data Definition (templates.tf)
# ==============================================================================

terraform {
  required_providers {
    template = {
      source  = "hashicorp/template"
      version = ">= 2.2.0"
    }
  }
}

data "template_file" "this" {
  template = file(var.template_path)
  vars     = var.template_vars
}

output "rendered" {
  description = "Rendered template output string"
  value       = data.template_file.this.rendered
}
