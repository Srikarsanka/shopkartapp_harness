# ==============================================================================
# Harness Service: Backend (Express.js) Microservice Definition
# ==============================================================================
# Flow:
# tfvars -> variables.tf -> data.template_file -> service.yaml -> module.services -> harness_platform_service

locals {
  backend_service_name       = "${var.app_name}-backend-service"
  backend_service_identifier = "${replace(var.app_name, "-", "_")}_backend_service"
}

# 1. Render YAML template with Terraform variables using data.template_file
data "template_file" "backend_service_tmpl" {
  template = file("${path.module}/_template_services/backend-service/service.yaml")

  vars = {
    name                 = local.backend_service_name
    identifier           = local.backend_service_identifier
    org_id               = var.org_id
    project_id           = var.project_id
    environment          = var.environment
    connector_ref        = var.git_connector_ref
    repo_name            = var.git_repo_name
    branch               = var.git_branch
    docker_connector_ref = var.docker_connector_ref
    image_path           = var.backend_image_repo
    log_level            = var.backend_log_level
  }
}

# 2. Instantiate reusable services module with rendered YAML
module "backend_service" {
  source = "./modules/services"

  identifier = local.backend_service_identifier
  name       = local.backend_service_name
  org_id     = var.org_id
  project_id = var.project_id
  yaml_data  = data.template_file.backend_service_tmpl.rendered

  tags = [
    "environment:${var.environment}",
    "tier:backend",
    "managed_by:terraform",
    "application:${var.app_name}"
  ]
}
