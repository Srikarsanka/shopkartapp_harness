# ==============================================================================
# Harness Platform Authentication Variables
# ==============================================================================

variable "harness_endpoint" {
  description = "The Harness API gateway URL"
  type        = string
  default     = "https://app.harness.io/gateway"
}

variable "harness_account_id" {
  description = "The 22-character unique Harness Account ID"
  type        = string
  default     = "demo_harness_account_id"

  validation {
    condition     = length(var.harness_account_id) > 0
    error_message = "The harness_account_id variable must not be empty."
  }
}

variable "harness_platform_api_key" {
  description = "Harness Service Account API token for platform authentication"
  type        = string
  sensitive   = true
  default     = "dummy_token_do_not_use_in_prod"
}

# ==============================================================================
# Hierarchy & Environment Variables
# ==============================================================================

variable "org_id" {
  description = "Target Harness Organization identifier"
  type        = string
  default     = "default"
}

variable "project_id" {
  description = "Target Harness Project identifier"
  type        = string
  default     = "shopkart_project"
}

variable "environment" {
  description = "Deployment environment name (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "app_name" {
  description = "Application base name"
  type        = string
  default     = "shopkart"
}

# ==============================================================================
# Connectors and Infrastructure References
# ==============================================================================

variable "git_connector_ref" {
  description = "Harness Git connector reference used for cloning manifests and repo triggers"
  type        = string
  default     = "account.github_shopkart_connector"
}

variable "git_repo_name" {
  description = "Name of the Git repository housing application source and manifests"
  type        = string
  default     = "shopkart-app"
}

variable "git_branch" {
  description = "Default Git branch for deployment and pipeline triggers"
  type        = string
  default     = "main"
}

variable "docker_connector_ref" {
  description = "Harness Docker/Container Registry connector reference"
  type        = string
  default     = "account.docker_hub_connector"
}

variable "k8s_connector_ref" {
  description = "Harness Kubernetes cluster connector reference for CI build infrastructure and CD rollouts"
  type        = string
  default     = "account.k8s_cluster_connector"
}

variable "backend_image_repo" {
  description = "Image repository URL for ShopKart backend"
  type        = string
  default     = "ghcr.io/example-user/shopkart-backend"
}

variable "frontend_image_repo" {
  description = "Image repository URL for ShopKart frontend"
  type        = string
  default     = "ghcr.io/example-user/shopkart-frontend"
}

variable "build_namespace" {
  description = "Kubernetes namespace used for ephemeral CI build runners"
  type        = string
  default     = "harness-build"
}

variable "environment_identifier" {
  description = "Harness Environment identifier target for CD deployment"
  type        = string
  default     = "shopkart_dev_env"
}

variable "infra_definition_identifier" {
  description = "Harness Infrastructure Definition identifier linking environment to target cluster"
  type        = string
  default     = "shopkart_k8s_dev_infra"
}

variable "artifact_tag" {
  description = "Artifact image tag supplied by default through Input Set"
  type        = string
  default     = "latest"
}
