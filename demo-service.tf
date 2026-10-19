# ==============================================================================
# Harness Service: ShopKart Microservice Definition
# ==============================================================================

locals {
  service_name       = "${var.app_name}-service"
  service_identifier = "${replace(var.app_name, "-", "_")}_service"

  # Render YAML definition using Terraform templatefile
  service_yaml = templatefile("${path.module}/_template_services/shopkart-service/service.yaml", {
    name                 = local.service_name
    identifier           = local.service_identifier
    org_id               = var.org_id
    project_id           = var.project_id
    environment          = var.environment
    connector_ref        = var.git_connector_ref
    repo_name            = var.git_repo_name
    branch               = var.git_branch
    docker_connector_ref = var.docker_connector_ref
    image_path           = var.backend_image_repo
  })
}

module "shopkart_service" {
  source = "./modules/services"

  identifier = local.service_identifier
  name       = local.service_name
  org_id     = var.org_id
  project_id = var.project_id
  yaml_data  = local.service_yaml

  tags = [
    "environment:${var.environment}",
    "managed_by:terraform",
    "application:${var.app_name}"
  ]
}
