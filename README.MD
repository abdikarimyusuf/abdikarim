🚀 App-Ingress-TLS & Cluster-Infrastructure
Deploy AWS EKS clusters & secure app routing with NGINX Ingress and Cert-Manager using Terraform.

📦 Project Structure
Phase 1: Cluster Infrastructure
text
eks.tf       → EKS cluster setup
node_group.tf → Worker nodes
iam.tf       → IAM roles & policies
vpc.tf       → Networking (VPC, subnets)
provider.tf  → Terraform provider config
variables.tf → Input variables
outputs.tf   → Terraform outputs
terraform.tfstate → Terraform state
Phase 2: App, Ingress & TLS
text
app.tf            → Application deployment
nginx_ingress.tf  → NGINX Ingress controller
cert_manager.tf   → Cert-Manager deployment
cert_issuer.tf    → ClusterIssuer (TLS)
ingress.tf        → Ingress rules
route53.tf        → DNS record setup
k8s_providers.tf  → Kubernetes provider
terraform.tfstate → Terraform state
⚠️ Initial Problem
Deploying everything at once caused:

CrashLoopBackOff for NGINX and app pods

Cert-Manager initialization failures

Route53 DNS creation errors

Reason: Terraform tried to deploy workloads before the cluster/nodes were ready.

🛠️ Solution: Two-Phase Deployment
1️⃣ Infrastructure First
text
graph TD;
    VPC --> EKS --> Nodes
Cluster and nodes are ready before app workloads.

2️⃣ App & Ingress Second
text
graph TD;
    Namespaces --> NGINX_Ingress --> Cert_Manager --> Applications_Ingress --> Route53_DNS
TLS and app routing deploy only after the cluster is up.

✅ Final Workflow
[Your Domain] → Route53 DNS → NGINX Load Balancer → Applications (+TLS)

📝 Key Learnings
Split deployments: Infra & workloads separate.

Always check logs: kubectl logs for troubleshooting.

Ignore .tfstate files in Git.

Use ConfigMaps for configurations.

🧑‍💻 Usage
bash
# Phase 1: Infrastructure
cd Cluster-Infrastructure
terraform init
terraform apply

# Phase 2: Applications & Ingress
cd App-Ingress-TLS
terraform init
terraform apply
🔎 Verification
kubectl get pods -A

kubectl get svc -n ingress-nginx

Enjoy a production-ready cluster with secure external access!

