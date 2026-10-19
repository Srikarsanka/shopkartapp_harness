# ShopKart Harness Infrastructure as Code (`shopkart-harness`)

Welcome to the **ShopKart Harness IaC Repository**. This repository models how a modern enterprise manages its **Harness Continuous Delivery & GitOps** infrastructure using **Terraform** and **declarative YAML templates**.

Rather than manually clicking through a web UI to configure services, pipelines, input sets, and triggers, DevOps engineers use this repository to treat the delivery platform itself as reproducible, version-controlled code.

---

## 1. End-to-End Architecture & Workflow

The diagram below illustrates how code flows from the developer's workstation into a container registry, how Kubernetes receives manifests, and how Terraform provisions the Harness pipelines that orchestrate the entire lifecycle.

```mermaid
flowchart TD
    subgraph AppRepo["Application Repo (shopkart-app)"]
        DEV[Developer Changes Code] --> GIT_COMMIT[Git Commit & Push]
        GIT_COMMIT --> APP_SRC[Angular & Node Source]
        GIT_COMMIT --> K8S_MANIFESTS[k8s/ Manifests]
    end

    subgraph CI_CD["Harness CI/CD Pipeline Execution"]
        TRIG[Git Push Webhook Trigger] --> PIPE[Harness Pipeline]
        PIPE --> CI_STAGE[CI Stage: npm test & Docker Build]
        CI_STAGE --> REGISTRY[(Container Registry: GHCR / DockerHub)]
        PIPE --> CD_STAGE[CD Stage: Rolling Kubernetes Deploy]
        REGISTRY --> CD_STAGE
        K8S_MANIFESTS --> CD_STAGE
        CD_STAGE --> CLUSTER[(Target Kubernetes Cluster: shopkart-dev)]
    end

    subgraph IaCRepo["Harness IaC Repo (shopkart-harness)"]
        TF_TEMPLATES[YAML Templates: _template_*] --> TF_RENDER[Terraform templatefile()]
        TF_RENDER --> TF_MODULES[Terraform Modules]
        TF_MODULES --> TF_STATE[(Terraform State)]
        TF_MODULES -->|Harness Terraform Provider| HARNESS_API[Harness NextGen Platform API]
    end

    HARNESS_API -->|Provisions & Updates| PIPE
    HARNESS_API -->|Provisions & Updates| TRIG
    APP_SRC -.->|Webhook Event| TRIG
```

---

## 2. Fundamental Concepts: Demystifying DevOps Terminology

When learning DevOps, terms like "manifest", "template", "module", and "state" can be confusing. Here is a clear breakdown:

| Concept | What It Is | Where It Lives | Purpose |
| :--- | :--- | :--- | :--- |
| **Application Source Code** | The actual logic written in TypeScript/JavaScript | `shopkart-app/frontend`, `backend` | Runs the e-commerce business logic (catalog, cart, API). |
| **Docker Images** | Immutable standalone packages of code + runtime | Container Registry (GHCR / Docker Hub) | Provides identical execution environments from laptop to production. |
| **Kubernetes Manifests** | Declarative YAML defining desired cluster state | `shopkart-app/k8s/` | Tells Kubernetes how many pods to run, memory limits, ports, and probes. |
| **Harness YAML Templates** | Parameterized YAML definitions with `${var}` placeholders | `shopkart-harness/_template_*/` | Blueprint for pipelines, services, and triggers before environment-specific values are injected. |
| **Rendered YAML** | Fully evaluated YAML produced by Terraform | Memory / Terraform Plan Output | The final payload sent over HTTP to the Harness Platform API. |
| **Terraform Modules** | Reusable Terraform code blocks | `shopkart-harness/modules/` | Encapsulates the provider resources (`harness_platform_pipeline`, etc.) for consistency. |
| **Harness-Managed Resources** | Live objects in the Harness SaaS platform | Harness Cloud Platform | The actual pipeline, trigger, or service executing builds and deployments. |
| **Terraform State** | Database mapping `.tf` files to real cloud IDs | `terraform.tfstate` (Remote S3 / GCS) | Tracks resource metadata and prevents conflicting concurrent updates. |

---

## 3. Directory Structure and Major Files

```text
shopkart-harness/
├── _template_services/
│   └── shopkart-service/
│       └── service.yaml         # Blueprint for Harness Kubernetes Service & Artifact Source
│
├── _template_pipelines/
│   └── shopkart-pipeline/
│       └── pipeline.yaml        # Blueprint for multi-stage CI/CD pipeline
│
├── _template_input_set/
│   └── shopkart-input-set/
│       └── inputset.yaml        # Blueprint for pipeline runtime values (tags, environment)
│
├── _template_trigger/
│   └── shopkart-trigger/
│       └── trigger.yaml         # Blueprint for Git push webhook triggers
│
├── environments/
│   └── env_dev.tfvars           # Development environment parameter definitions
│
├── modules/
│   ├── services/                # Encapsulates harness_platform_service resource
│   ├── pipelines/               # Encapsulates harness_platform_pipeline resource
│   ├── input-sets/              # Encapsulates harness_platform_input_set resource
│   └── triggers/                # Encapsulates harness_platform_triggers resource
│
├── resources/
│   ├── README.md                # Explains supporting architectural assets
│   └── sample-connectors.yaml   # Reference configuration for GitHub/Docker/K8s connectors
│
├── demo-service.tf              # Renders service template and calls services module
├── demo-pipeline.tf             # Renders pipeline template and calls pipelines module
├── demo-input-set.tf            # Renders input set template and calls input-sets module
├── demo-trigger.tf              # Renders trigger template and calls triggers module
├── variables.tf                 # Variable declarations, validation rules, and descriptions
├── versions.tf                  # Declares Terraform >= 1.5.0 and harness provider >= 0.30
├── providers.tf                 # Configures harness provider with credentials & gateway
├── outputs.tf                   # Exposes resource IDs and fully rendered YAMLs for inspection
├── .gitignore                   # Excludes state files, cache, and sensitive local tfvars
└── README.md                    # This documentation file
```

---

## 4. How Terraform Template Interpolation Works

In Harness pipelines, two syntax systems meet:
1. **Terraform Interpolation (`${...}`)**: Evaluated locally by Terraform's `templatefile()` function using variables passed from `demo-*.tf`.
2. **Harness Expressions (`<+...>` or `${...}`)**: Evaluated by the Harness Platform at pipeline runtime (e.g., `<+pipeline.sequenceId>`, `<+input>`).

### Escaping Syntax Rule
When literal `${...}` syntax is needed inside a Harness YAML template, Terraform's parser would normally crash if that variable isn't defined in the Terraform map. To preserve it for Harness, escape it with a double dollar sign:
```yaml
# In template file (pipeline.yaml):
description: "Pipeline for $${app_name:-shopkart} managed via Terraform"

# Renders as literal string for Harness:
description: "Pipeline for ${app_name:-shopkart} managed via Terraform"
```
Harness native runtime inputs using `<+...>` (such as `<+pipeline.sequenceId>` or `<+input>`) do not collide with Terraform and can be used directly.

---

## 5. Terraform Execution Guide

### Step 1: Initialize Terraform
Downloads the official Harness provider plugin (`harness/harness`) and initializes child modules.

```powershell
# Navigate to harness directory
cd Learning/shopkart-harness

# Initialize provider and modules
terraform init
```

### Step 2: Format & Validate Configuration
Ensures HCL syntax conforms to HashiCorp standards and checks internal reference consistency.

```powershell
# Format code recursively
terraform fmt -recursive

# Validate syntactical correctness
terraform validate
```

### Step 3: Inspect the Execution Plan (Offline Safe)
Inspects the changes Terraform would make against your Harness organization without making any real cloud modifications. Because our `outputs.tf` exposes rendered YAML, this also prints the exact YAML payload that will be submitted!

```powershell
# Run speculative execution plan using development tfvars
terraform plan -var-file="environments/env_dev.tfvars"
```

### Step 4: Apply Configuration (Requires Valid Harness Account)
When connecting to a real Harness SaaS account, pass your API key securely:

```powershell
# Set API Key via environment variable (Never hardcode secrets!)
$env:HARNESS_PLATFORM_API_KEY = "pat.your_real_harness_secret_token"
$env:HARNESS_ACCOUNT_ID = "your_actual_account_id"

# Apply changes with an approved plan file
terraform plan -var-file="environments/env_dev.tfvars" -out="dev.tfplan"
terraform apply "dev.tfplan"
```

### Step 5: Inspect State & Outputs
```powershell
# View all resource identifiers and rendered templates
terraform output

# View specific rendered pipeline YAML
terraform output -raw rendered_pipeline_yaml
```

### Step 6: Safe Resource Destruction
When removing demo resources to prevent clutter or cloud costs:
```powershell
terraform destroy -var-file="environments/env_dev.tfvars"
```

---

## 6. Terraform State Management: Critical Rules

1. **What is State?**: Terraform records the relationship between your configuration files and actual cloud resources in `terraform.tfstate`.
2. **Local vs Remote State**:
   - In local development, `terraform.tfstate` is saved on your local disk.
   - In production teams, state is stored in a **Remote Backend** (e.g., AWS S3 with DynamoDB state locking, Google Cloud Storage, or Terraform Cloud). Remote state provides **atomic locking**, preventing two team members from applying changes simultaneously.
3. **Never Commit State to Git**:
   - State files contain sensitive resource metadata and potentially plaintext variable values.
   - Committing state leads to merge conflicts and state file corruption.
   - State files are explicitly ignored in our `.gitignore`.

---

## 7. Authentication & Security Best Practices

To authenticate to Harness without hardcoding tokens in Git:
- **Option A (Environment Variables - Recommended)**:
  ```powershell
  $env:HARNESS_PLATFORM_API_KEY = "pat.xxx"
  $env:HARNESS_ACCOUNT_ID = "your_account_id"
  ```
- **Option B (Separate Secret tfvars)**:
  Create `secrets.secret.tfvars` (ignored by Git):
  ```hcl
  harness_platform_api_key = "pat.xxx"
  harness_account_id       = "your_account_id"
  ```
  And execute with:
  ```powershell
  terraform plan -var-file="environments/env_dev.tfvars" -var-file="secrets.secret.tfvars"
  ```
