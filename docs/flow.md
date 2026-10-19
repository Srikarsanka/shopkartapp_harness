# Enterprise Architecture & End-to-End Data Flow

This document details the architectural blueprint and operational data flow of the **ShopKart Harness + Terraform** repository (`shopkart-harness`).

It bridges the conceptual gap between:
1. **Terraform Infrastructure as Code (IaC)** provisioning declarative configuration into the Harness Platform.
2. **Harness Platform Runtime Execution (CI/CD)** automating application build, containerization, and rollout to Kubernetes.

---

## 1. Architectural Overview & Separation of Concerns

In modern enterprise DevOps, infrastructure repositories and application repositories operate independently:

```mermaid
flowchart LR
    subgraph AppRepo["Application Repository (shopkart-app)"]
        Src["Source Code (Angular & Express)"]
        Docker["Dockerfiles (Frontend & Backend)"]
        K8s["Kubernetes Manifests (Deployments, Services, ConfigMaps)"]
    end

    subgraph IaCRepo["Harness IaC Repository (shopkart-harness)"]
        Tfvars["environments/*.tfvars"]
        Templates["_template_* (YAML Skeletons)"]
        Modules["modules/* (Terraform Modules)"]
        RootTF["*.tf (Composition Root)"]
    end

    subgraph HarnessPlatform["Harness NextGen Platform"]
        Services["Harness Services"]
        Pipelines["Harness CI/CD Pipelines"]
        Triggers["Webhook Triggers"]
        Overrides["Service Overrides"]
        InputSets["Input Sets"]
    end

    subgraph Runtime["Runtime Cloud Infrastructure (GKE / Kubernetes)"]
        K8sCluster["Target Cluster (dev / qa / prod)"]
    end

    IaCRepo -->|"terraform apply"| HarnessPlatform
    AppRepo -->|"git push (Webhook)"| Triggers
    Triggers --> Pipelines
    Pipelines -->|"Pulls Manifests & Code"| AppRepo
    Pipelines -->|"Builds & Deploys"| Runtime
```

### Key Distinction: Provisioning vs. Execution
* **Terraform Provisioning (Day 0 / Day 1):** Terraform provisions the Harness entities: it registers the Services, establishes the Pipelines, configures the Webhook Triggers, attaches Input Sets, and applies Environment Overrides. It does **not** deploy application containers.
* **Harness Pipeline Execution (Day 2):** When a developer pushes code to GitHub, GitHub fires a webhook. The Harness Trigger catches this event, executes the pre-provisioned Pipeline, builds the Docker image, and executes a rolling rollout to Kubernetes.

---

## 2. End-to-End Terraform Data Flow

Data flows through a structured, multi-tier pipeline in Terraform before reaching the Harness Platform API:

```mermaid
flowchart TD
    subgraph Tier1["1. Environment Inputs"]
        TFVARS["environments/dev.tfvars\n(Environment specific parameters)"]
    end

    subgraph Tier2["2. Variable Contract"]
        VARS["variables.tf\n(Type definitions, defaults, constraints)"]
    end

    subgraph Tier3["3. Template Rendering Engine"]
        ROOT_TF["frontend-service.tf / backend-service.tf\n(Root Resource Definitions)"]
        RAW_YAML["_template_services/*/service.yaml\n(Raw YAML with ${placeholders})"]
        DATA_TMPL["data.template_file\n(Terraform Interpolation Engine)"]
    end

    subgraph Tier4["4. Rendered Contract"]
        RENDERED["Rendered YAML Payload\n(Valid, well-formed Harness NG YAML)"]
    end

    subgraph Tier5["5. Reusable Infrastructure Modules"]
        MOD_SVC["modules/services/services.tf\n(Resource Abstraction Module)"]
    end

    subgraph Tier6["6. Harness Platform Provider"]
        PROVIDER["harness_platform_service\n(Harness Terraform Provider)"]
        HARNESS_API["Harness NextGen REST API / Gateway"]
    end

    subgraph Tier7["7. Harness Cloud Entity"]
        ENTITY["Harness Platform Service Object"]
    end

    TFVARS -->|"CLI flag -var-file"| VARS
    VARS -->|"var.image_repo, var.env"| ROOT_TF
    RAW_YAML -->|"file()"| DATA_TMPL
    ROOT_TF -->|"vars = { ... }"| DATA_TMPL
    DATA_TMPL -->|"data.template_file.rendered"| RENDERED
    RENDERED -->|"yaml_data input"| MOD_SVC
    MOD_SVC -->|"yaml argument"| PROVIDER
    PROVIDER -->|"HTTP POST/PUT"| HARNESS_API
    HARNESS_API -->|"Instantiates"| ENTITY
```

---

## 3. Deep Dive: The Template Rendering Mechanics

### Why Enterprises Use YAML Templates in Terraform
In Harness, complex entities (Pipelines, Services, Triggers) are defined natively in YAML. Rather than attempting to represent thousands of lines of deeply nested YAML structures as native HCL blocks, enterprise organizations store clean, version-controlled YAML templates in `_template_*` directories and inject dynamic values using Terraform.

### The `data.template_file` vs `templatefile()` Evolution
1. **`data.template_file` (Legacy / Enterprise Standard):**
   - Originally part of `hashicorp/template`.
   - Uses data source lifecycle:
     ```terraform
     data "template_file" "frontend_pipeline_tmpl" {
       template = file("${path.module}/_template_pipelines/frontend-pipeline/pipeline.yaml")
       vars = {
         service_identifier = module.frontend_service.identifier
         environment        = var.environment
       }
     }
     ```
   - **Why large enterprises still use it:** Many enterprise governance frameworks, CI/CD runners, and internal wrappers were architected around data sources and graph dependencies.
   - **Important Syntax Note:** In `data.template_file`, literal bash variables in scripts (e.g. `$${BUILD_ID}`) must use double dollar signs (`$$`) to prevent Terraform interpolation errors.
2. **`templatefile()` (Modern Built-in):**
   - Introduced in Terraform 0.12 as a native function, removing the need for an external provider.
   - `service_yaml = templatefile("path", { vars })`

---

## 4. Frontend vs. Backend Deployment Architecture

ShopKart separates Frontend and Backend configurations to ensure independent deployment lifecycles, zero-downtime rollouts, and distinct security boundaries.

| Architectural Dimension | Frontend Service (`frontend-*`) | Backend Service (`backend-*`) |
| :--- | :--- | :--- |
| **Technology Stack** | Angular SPA (Nginx container) | Node.js / Express.js REST API |
| **Port** | `80` (HTTP) | `5000` (API) |
| **CI Build Stage** | `npm ci` & `ng test` / ChromeHeadless | `npm ci` & Mocha/Jest unit tests |
| **Docker Build** | `docker/Dockerfile.frontend` | `docker/Dockerfile.backend` |
| **Service Overrides** | Replica count, CDN endpoints, API URLs | Database URIs (MongoDB Atlas), connection pools, secret tokens |
| **Rollout Strategy** | Rolling deploy, immediate cache busting | Rolling deploy with database connectivity smoke test |

---

## 5. Webhook-Driven CI/CD Execution Flow

When a developer works on application code in `shopkart-app`:

```mermaid
sequenceDiagram
    autonumber
    actor Dev as Developer
    participant Git as GitHub (shopkart-app)
    participant Trig as Harness Trigger (Webhook)
    participant Pipe as Harness Pipeline
    participant CI as CI Runner (K8s Direct)
    participant Reg as Container Registry (GHCR/DockerHub)
    participant CD as CD Rolling Deployer
    participant K8s as Target Kubernetes Cluster (GKE)

    Dev->>Git: git push origin develop
    Git->>Trig: POST /gateway/api/webhooks (X-GitHub-Event: push)
    Note over Trig: Evaluates targetBranch == develop<br/>Evaluates repo == shopkart-app
    Trig->>Pipe: Execute Pipeline (shopkart_backend_pipeline)
    Pipe->>CI: Spin up build runner in harness-build namespace
    CI->>Git: Clone repository codebase
    CI->>CI: Run npm ci & execute unit tests
    CI->>Reg: Build and push Docker image with tag (e.g. dev-latest, sequenceId)
    Pipe->>CD: Initiate CD Deployment stage
    CD->>K8s: Apply k8s/backend-deployment.yaml with new image tag
    CD->>K8s: Rollout status check & health verification
    K8s-->>CD: Pods Healthy (Ready 1/1)
    CD-->>Pipe: Stage Complete
    Pipe-->>Dev: Pipeline Successful
```

---

## 6. How Environment Promotion Works (`dev` -> `qa` -> `prod`)

Promotion across environments does **not** alter the core pipeline or service architecture. It only swaps the parameter values supplied via `.tfvars`:

```bash
# 1. Plan for Development
terraform plan -var-file="environments/dev.tfvars"

# 2. Plan for QA / Staging
terraform plan -var-file="environments/qa.tfvars"

# 3. Plan for Production
terraform plan -var-file="environments/prod.tfvars"
```

### Impact of Environment Swapping:
1. **Target Cluster:** `k8s_connector_ref` switches from `account.kubernetes_dev_cluster` to `account.kubernetes_prod_cluster`.
2. **Namespace & Isolation:** Deployments land in dedicated environment namespaces (`dev`, `qa`, `prod`).
3. **Resource Allocations:** Pod memory limits increase from `256Mi` in Dev to `1Gi` in Prod; CPU limits scale from `250m` to `1000m`.
4. **Replication & High Availability:** Prod spins up 4 backend pods and 3 frontend pods; Dev operates with single replicas to conserve cluster cost.
5. **Observability:** `backend_log_level` shifts from verbose `debug` in Dev to optimized `warn` in Prod.
6. **Data Storage:** Backend binds to isolated internal test databases in Dev/QA and connects to managed MongoDB Atlas clusters in Prod.

---

## 7. Triggers, Input Sets, and Overrides Integration

```mermaid
graph TD
    subgraph PipelineSpec["Harness Pipeline (Skeleton Template)"]
        BasePipeline["Pipeline: Stages declared with <+input> placeholders"]
    end

    subgraph RuntimeParameters["Runtime Parameterization"]
        InputSet["Input Set: Supplies default runtime tags & artifact references"]
        Overrides["Service Overrides: Supplies cluster-level env vars & resource limits"]
        Trigger["Git Trigger: Injects branch, commit SHA, and event metadata"]
    end

    subgraph FinalExecution["Resolved Execution Payload"]
        ResolvedRun["Executing Pipeline Instance on Kubernetes"]
    end

    BasePipeline --> ResolvedRun
    InputSet -->|"Resolves <+input> artifact tags"| ResolvedRun
    Overrides -->|"Injects env-specific limits & URLs"| ResolvedRun
    Trigger -->|"Supplies <+trigger.branch> & commits"| ResolvedRun
```

* **Pipeline Skeleton:** Leaves environment-variable bindings and artifact tags as `<+input>`, making the pipeline generic and reusable across all stages.
* **Input Sets (`inputset.yaml`):** Store concrete runtime parameters for specific deployment targets without hardcoding values into the pipeline.
* **Service Overrides (`override.yaml`):** Adjust environment-specific variables (such as memory limits, replica counts, and ConfigMap values) dynamically when the service is deployed to a given environment.
* **Webhook Triggers (`trigger.yaml`):** Intercept GitHub events, inject runtime payload variables (`<+trigger.branch>`), and launch the pipeline automatically.
