# 🚀 App-Ingress-TLS & Cluster-Infrastructure

**Deploy AWS EKS clusters & secure app routing with NGINX Ingress and Cert-Manager using Terraform.**

***

## 📦 Project Structure

### Phase 1: Cluster Infrastructure

eks.tf → EKS cluster setup
node_group.tf → Worker nodes
iam.tf → IAM roles & policies
vpc.tf → Networking (VPC, subnets)
provider.tf → Terraform provider config
variables.tf → Input variables
outputs.tf → Terraform outputs
terraform.tfstate → Terraform state

text

### Phase 2: App, Ingress & TLS

app.tf → Application deployment
nginx_ingress.tf → NGINX Ingress controller
cert_manager.tf → Cert-Manager deployment
cert_issuer.tf → ClusterIssuer (TLS)
ingress.tf → Ingress rules
route53.tf → DNS record setup
k8s_providers.tf → Kubernetes provider
terraform.tfstate → Terraform state

text

***

## ⚠️ Initial Problem

- CrashLoopBackOff for NGINX and app pods
- Cert-Manager initialization failures
- Route53 DNS creation errors

**Reason:** Terraform tried to deploy workloads before the cluster/nodes were ready.

***

## 🛠️ Solution: Two-Phase Deployment

**Phase 1 – Infrastructure**  
Build: VPC → EKS Cluster → Node Groups (workers)  
*Outcome: Cluster and nodes are ready; Terraform tracks infrastructure*

**Phase 2 – Apps & Routing**  
Deploy: Namespaces → NGINX Ingress → Cert-Manager (TLS) → Applications (+Ingress) → Route53 DNS  
*Outcome: Apps available via your domain, TLS auto-applied, NGINX routes traffic correctly*

***

## ✅ Final Workflow

- [Your Domain] → Route53 DNS → NGINX Load Balancer → Applications (+TLS)

***

## 📝 Key Learnings

- Split deployments: Infra & workloads separate
- Always check logs: `kubectl logs`
- Ignore `.tfstate` files in Git
- Use ConfigMaps for configuration

***

## 🧑‍💻 How to Use

```bash
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

Confirm your DNS record points to the NGINX load balancer

Enjoy a production-ready EKS cluster with secure, automated TLS!