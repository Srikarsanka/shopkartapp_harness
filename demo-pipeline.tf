# ==============================================================================
# Harness Pipeline: ShopKart CI/CD Delivery Pipeline
# ==============================================================================

locals {
  pipeline_name       = "${var.app_name}-ci-cd-pipeline"
  pipeline_identifier = "${replace(var.app_name, "-", "_")}_ci_cd_pipeline"

  # Render YAML definition using Terraform templatefile
  pipeline_yaml = templatefile("${path.module}/_template_pipelines/shopkart-pipeline/pipeline.yaml", {
    name                        = local.pipeline_name
    identifier                  = local.pipeline_identifier
    project_id                  = var.project_id
    org_id                      = var.org_id
    environment                 = var.environment
    k8s_connector_ref           = var.k8s_connector_ref
    build_namespace             = var.build_namespace
    docker_connector_ref        = var.docker_connector_ref
    backend_image_repo          = var.backend_image_repo
    service_identifier          = module.shopkart_service.identifier
    environment_identifier      = var.environment_identifier
    infra_definition_identifier = var.infra_definition_identifier
  })
}

module "shopkart_pipeline" {
  source = "./modules/pipelines"

  identifier = local.pipeline_identifier
  name       = local.pipeline_name
  org_id     = var.org_id
  project_id = var.project_id
  yaml_data  = local.pipeline_yaml

  tags = [
    "environment:${var.environment}",
    "managed_by:terraform",
    "application:${var.app_name}"
  ]

  depends_on = [
    module.shopkart_service
  ]
}
