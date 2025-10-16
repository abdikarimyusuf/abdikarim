# 🚀 App-Ingress-TLS & Cluster-Infrastructure

Deploy AWS EKS clusters & secure app routing with NGINX Ingress and Cert-Manager using Terraform.

---

## 📦 Project Structure

### Phase 1: Cluster Infrastructure

- `eks.tf`: EKS cluster setup
- `node_group.tf`: Worker nodes
- `iam.tf`: IAM roles & policies
- `vpc.tf`: Networking (VPC, subnets)
- `provider.tf`: Terraform provider config
- `variables.tf`: Input variables
- `outputs.tf`: Terraform outputs
- `terraform.tfstate`: Terraform state

### Phase 2: App, Ingress & TLS

- `app.tf`: Application deployment
- `nginx_ingress.tf`: NGINX Ingress controller
- `cert_manager.tf`: Cert-Manager deployment
- `cert_issuer.tf`: ClusterIssuer (TLS)
- `ingress.tf`: Ingress rules
- `route53.tf`: DNS record setup
- `k8s_providers.tf`: Kubernetes provider
- `terraform.tfstate`: Terraform state

---

## ⚠️ Initial Problem

- CrashLoopBackOff for NGINX and app pods
- Cert-Manager initialization failures
- Route53 DNS creation errors

> **Reason:** Terraform tried to deploy workloads before the cluster/nodes were ready.

---

## 🛠️ Solution: Two-Phase Deployment

### Phase 1 – Infrastructure

Build: VPC → EKS Cluster → Node Groups  
*Clusters and nodes are ready; Terraform tracks infrastructure.*

### Phase 2 – Apps & Routing

Deploy: Namespaces → NGINX Ingress → Cert-Manager (TLS) → Applications (+Ingress) → Route53 DNS  
*Apps available via your domain, TLS certs auto-applied, NGINX routes traffic correctly.*

---

## ✅ Final Workflow

| Step                   | Description                        |
|------------------------|------------------------------------|
| [abdikarim.co.uk]          | Public web domain                  |
| Route53 DNS            | AWS DNS service                    |
| NGINX Load Balancer    | Ingress routing                    |
| Applications (+TLS)    | Secured app endpoints              |

---

## 📝 Key Learnings

- Use two-phase Terraform for EKS
- Always check logs: `kubectl logs`
- Ignore `.tfstate` files in Git
- Use ConfigMaps for app configuration

---

## 🧑‍💻 How to Use

Phase 1: Cluster-Infrastructure
cd Cluster-Infrastructure
terraform init
terraform apply

Phase 2: App-Ingress-TLS
cd App-Ingress-TLS
terraform init
terraform apply

text

---

## 🔎 Verification

- `kubectl get pods -A`
- `kubectl get svc -n ingress-nginx`
- Confirm your DNS record points to the NGINX load balancer

---

## 🏆 Key Learnings

- **Phase your deployments:** Create infrastructure first, workloads second, to avoid dependency and timing issues.
- **Check pod logs:** Use `kubectl logs <pod-name>` for critical troubleshooting and verification.
- **Two-phase Terraform approach:** Prevents resource creation failures in EKS by cleanly separating cluster/infra and application/workload provisioning.
- **Use ConfigMaps if needed:** Helps applications communicate configurations.
- **Ignore Terraform state files in Git:** Prevent conflicts and accidental commits.

---

**Enjoy a production-ready EKS cluster with secure, automated TLS!**


