App-Ingress-TLS & Cluster-Infrastructure
Overview

This project demonstrates how to deploy applications on AWS EKS using Terraform, with NGINX Ingress for routing and Cert-Manager for automatic TLS certificates.

The project is split into two phases to avoid timing and dependency issues when creating clusters, nodes, and workloads.

Project Structure
Phase 1 → Cluster-Infrastructure
├─ eks.tf           # EKS cluster setup
├─ node_group.tf    # Worker nodes
├─ iam.tf           # IAM roles and policies
├─ vpc.tf           # Networking setup (VPC, subnets)
├─ provider.tf      # Terraform provider configuration
├─ variables.tf     # Input variables
├─ outputs.tf       # Terraform outputs
└─ terraform.tfstate

Phase 2 → App-Ingress-TLS
├─ app.tf           # Application deployment
├─ nginx_ingress.tf # NGINX Ingress controller
├─ cert_manager.tf  # Cert-Manager deployment
├─ cert_issuer.tf   # ClusterIssuer for TLS
├─ ingress.tf       # Ingress rules
├─ route53.tf       # DNS record setup
├─ k8s_providers.tf # Kubernetes provider configuration
└─ terraform.tfstate

Initial Problem

When I tried to deploy everything at once, errors occurred:

Pods for NGINX and applications were CrashLoopBackOff.

Cert-Manager failed to initialize.

Route53 DNS records could not be created.

Why?
Terraform tried to create apps, ingress, and DNS before the cluster and node groups were ready. Resources depend on each other, and timing matters in Kubernetes.

Solution: Two-Phase Deployment
Phase 1: Cluster Setup

Create the infrastructure first: VPC, EKS cluster, and node groups.

┌─────────┐
│  VPC    │
└─────────┘
     │
┌─────────┐
│ EKS     │
└─────────┘
     │
┌─────────┐
│ Nodes   │
└─────────┘


Outcome:

Cluster and nodes are ready.

Terraform tracks infrastructure state.

Phase 2: Application & Ingress Setup

Deploy applications, NGINX Ingress, Cert-Manager, and DNS after the cluster is ready.

┌───────────────┐
│  Namespaces    │
└───────────────┘
     │
┌───────────────┐
│  NGINX        │
│ Ingress       │
└───────────────┘
     │
┌───────────────┐
│ Cert-Manager  │
│ (TLS)         │
└───────────────┘
     │
┌───────────────┐
│  Applications │
│ + Ingress     │
└───────────────┘
     │
┌───────────────┐
│  Route53 DNS  │
│ (Domain → NGINX) │
└───────────────┘


Outcome:

Applications are accessible via your domain.

TLS certificates are automatically applied.

NGINX routes traffic correctly.

Key Learnings

Phase your deployments: Create infrastructure first, workloads second.

Check pod logs: kubectl logs <pod-name> is critical for troubleshooting.

Two-phase Terraform approach: Prevents timing issues in EKS.

Use ConfigMaps if needed: Helps apps communicate configurations.

Ignore Terraform state files in Git: Prevent conflicts and accidental commits.

How to Use

Phase 1: Infrastructure


Phase 2: Apps & Ingress

cd App-Ingress-TLS
terraform init
terraform apply


Verify Pods

kubectl get pods -A


Check NGINX Ingress

kubectl get svc -n ingress-nginx


Verify DNS

Check that your domain points to the load balancer.

Final Result

After both phases:

[Your Domain] → Route53 → NGINX Load Balancer → Applications
                                │
                                └→ TLS via Cert-Manager


Everything is running in a ready-to-use Kubernetes cluster with external access and secure connections.