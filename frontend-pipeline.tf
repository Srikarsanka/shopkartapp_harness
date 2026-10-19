# ==============================================================================
# Harness Pipeline: Frontend CI/CD Pipeline Definition
# ==============================================================================
# Flow:
# tfvars -> variables.tf -> data.template_file -> pipeline.yaml -> module.pipelines -> harness_platform_pipeline

locals {
  frontend_pipeline_name       = "${var.app_name}-frontend-pipeline"
  frontend_pipeline_identifier = "${replace(var.app_name, "-", "_")}_frontend_pipeline"
}

# 1. Render Pipeline YAML template using data.template_file
data "template_file" "frontend_pipeline_tmpl" {
  template = file("${path.module}/_template_pipelines/frontend-pipeline/pipeline.yaml")

  vars = {
    name                        = local.frontend_pipeline_name
    identifier                  = local.frontend_pipeline_identifier
    org_id                      = var.org_id
    project_id                  = var.project_id
    service_identifier          = module.frontend_service.identifier
    environment                 = var.environment
    environment_identifier      = var.environment_identifier
    infra_definition_identifier = var.infra_definition_identifier
    git_connector_ref           = var.git_connector_ref
    repo_name                   = var.git_repo_name
    branch                      = var.git_branch
    docker_connector_ref        = var.docker_connector_ref
    image_path                  = var.frontend_image_repo
    k8s_connector_ref           = var.k8s_connector_ref
    build_namespace             = var.build_namespace
  }
}

# 2. Instantiate reusable pipelines module with rendered YAML
module "frontend_pipeline" {
  source = "./modules/pipelines"

  identifier = local.frontend_pipeline_identifier
  name       = local.frontend_pipeline_name
  org_id     = var.org_id
  project_id = var.project_id
  yaml_data  = data.template_file.frontend_pipeline_tmpl.rendered

  tags = [
    "environment:${var.environment}",
    "tier:frontend",
    "managed_by:terraform",
    "application:${var.app_name}"
  ]

  depends_on = [module.frontend_service]
}
