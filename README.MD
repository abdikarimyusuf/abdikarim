App-Ingress-TLS & Cluster-Infrastructure
Project Structure

You have two main folders, each representing a phase of your setup:

Cluster-Infrastructure – sets up the actual Kubernetes cluster and its supporting resources (VPC, node groups, IAM roles).

Files: eks.tf, iam.tf, node_group.tf, vpc.tf, provider.tf, etc.

This is Phase 1.

App-Ingress-TLS  deploys applications, NGINX Ingress, Cert-Manager, and DNS setup.

Files: app.tf, nginx_ingress.tf, cert_manager.tf, cert_issuer.tf, route53.tf, etc.

This is Phase 2.

Initial Problem

When I tried to deploy everything at once:

Terraform tried to create apps, ingress, and DNS before the cluster and node groups were fully ready.

Pods kept crashing (CrashLoopBackOff) because dependencies weren’t ready yet.

Cert-Manager and Route53 creation failed due to missing services or load balancer not being ready.

Basically, the timing of resource creation in Kubernetes matters—a pod or service can’t exist if the cluster isn’t ready to host it.

Solution: Two-Phase Deployment
Phase 1: Cluster Setup (Cluster-Infrastructure)

Goal: Make sure the Kubernetes cluster and node groups are fully created before anything else runs.

Create the EKS cluster (eks.tf)

Set up IAM roles for the nodes (iam.tf)

Create node groups (node_group.tf)

Configure networking with VPC (vpc.tf)

✅ Result:

Kubernetes cluster exists and is ready to run workloads.

Nodes are up and can host pods.

Terraform has tracked the cluster state safely.

Phase 2: Application & Ingress Setup (App-Ingress-TLS)

Goal: Deploy apps, NGINX Ingress, Cert-Manager, and DNS on top of the existing cluster.

Create namespaces, service accounts, and roles for NGINX and apps.

Deploy NGINX Ingress Controller to handle traffic.

Deploy Cert-Manager and ClusterIssuer for TLS.

Create Route53 DNS records to point your domain to the NGINX load balancer.

Deploy sample applications with Ingress rules.

✅ Result:

NGINX Ingress routes traffic to the apps.

TLS certificates are automatically created.

Domain points correctly to your apps.

Key Takeaways

Cluster first, apps second: You cannot run workloads before the cluster is ready.

Split deployment into phases: This prevents timing issues and pod crashes.

Use ConfigMaps for coordination: Helps translate between apps, ingress, and services.

Terraform state files: Keep track of infrastructure changes; ignore them in Git to prevent conflicts.

Check pods and logs: Pods crashing (CrashLoopBackOff) usually mean missing permissions, configs, or environment variables.

Visual Flow (Conceptual)
Phase 1: Cluster-Infrastructure
+---------------------+
|      VPC + EKS      |
|   Node Groups + IAM |
+---------------------+
           |
           v
Phase 2: App-Ingress-TLS
+--------------------------+
| NGINX Ingress Controller |
| Cert-Manager             |
| Applications + Ingress   |
| Route53 DNS              |
+--------------------------+
           |
           v
      Your Domain -> Apps
