# Harness Resources Directory (`resources/`)

## Purpose of this Directory

In enterprise Infrastructure as Code (IaC) repositories, the `resources/` folder holds **reusable supporting assets and reference configurations** that are not directly instantiated by the primary Terraform root modules, but are essential for context, documentation, and external dependencies.

### What Belongs Here:
1. **Supporting Reference Configurations**: Examples of prerequisite Harness Connectors (`sample-connectors.yaml`) showing how Git repositories, Docker registries, and Kubernetes clusters are linked to Harness Delegates.
2. **Architecture and Data Flow Schemas**: Diagrams, payload examples for webhooks, or sample Secret schemas.
3. **External Platform Templates**: Common role-based access control (RBAC) templates or delegate installation guides.

### What Does NOT Belong Here:
- Active Terraform resources: Resources managed by Terraform belong in `modules/` and root `.tf` files (`demo-*.tf`) to avoid drift or duplicate state definitions.
- Credentials, private keys, or plain-text secrets: All secrets should reside in Harness Secret Manager or cloud KMS solutions.
