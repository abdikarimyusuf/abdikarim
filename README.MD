App-Ingress-TLS & Cluster-Infrastructure Overview

This project shows how to deploy applications on AWS EKS using Terraform, with NGINX Ingress for routing and Cert-Manager for automatic TLS certificates.

We split the deployment into two phases to avoid timing and dependency issues between clusters, node groups, and workloads.

Project Structure
Phase 1 → Cluster-Infrastructure

eks.tf → EKS cluster setup

node_group.tf → Worker nodes

iam.tf → IAM roles and policies

vpc.tf → Networking (VPC, subnets)

provider.tf → Terraform provider configuration

variables.tf → Input variables

outputs.tf → Terraform outputs

terraform.tfstate → Terraform state

Phase 2 → App-Ingress-TLS

app.tf → Application deployment

nginx_ingress.tf → NGINX Ingress controller

cert_manager.tf → Cert-Manager deployment

cert_issuer.tf → ClusterIssuer for TLS

ingress.tf → Ingress rules

route53.tf → DNS record setup

k8s_providers.tf → Kubernetes provider

terraform.tfstate → Terraform state

Initial Problem

When attempting to deploy everything at once:

NGINX and app pods went into CrashLoopBackOff.

Cert-Manager failed to initialize.

Route53 DNS records could not be created.

Why? Terraform tried to create apps, ingress, and DNS before the cluster and node groups were ready. Kubernetes resources depend on each other, and timing matters.

Solution: Two-Phase Deployment
Phase 1: Cluster Setup

Create infrastructure first: VPC, EKS cluster, and node groups.

┌─────────┐    ┌─────────┐    ┌─────────┐
│  VPC    │ →  │  EKS    │ →  │ Nodes   │
└─────────┘    └─────────┘    └─────────┘


Outcome:

Cluster and nodes are ready.

Terraform tracks infrastructure state.

Phase 2: Application & Ingress Setup

Deploy applications, NGINX Ingress, Cert-Manager, and DNS after the cluster is ready.

┌───────────────┐
│ Namespaces    │
└───────────────┘
       │
┌───────────────┐
│ NGINX Ingress │
└───────────────┘
       │
┌───────────────┐
│ Cert-Manager  │
│   (TLS)       │
└───────────────┘
       │
┌───────────────┐
│ Applications  │
│ + Ingress     │
└───────────────┘
       │
┌───────────────┐
│ Route53 DNS   │
│ Domain → NGINX│
└───────────────┘


Outcome:

Applications are accessible via your domain.

TLS certificates are applied automatically.

NGINX routes traffic correctly.

Key Learnings

Phase deployments: Create infrastructure first, workloads second.

Check pod logs: kubectl logs is critical for troubleshooting.

Two-phase Terraform approach: Prevents timing issues in EKS.

ConfigMaps: Can help apps communicate configurations.

Ignore Terraform state files in Git: Prevent conflicts and accidental commits.

How to Use
Phase 1: Infrastructure
cd Cluster-Infrastructure
terraform init
terraform apply

Phase 2: Apps & Ingress
cd App-Ingress-TLS
terraform init
terraform apply


Verify Pods

kubectl get pods -A


Check NGINX Ingress

kubectl get svc -n ingress-nginx


Verify DNS

Ensure your domain points to the load balancer.

Final Result
[Your Domain] → Route53 → NGINX Load Balancer → Applications
                            └→ TLS via Cert-Manager


Everything runs in a ready-to-use Kubernetes cluster with external access and secure connections.