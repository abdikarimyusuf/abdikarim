resource "kubernetes_namespace" "ingress_nginx" {
  provider = kubernetes.eks
    metadata { 
        
        name = "ingress-nginx"
      
    }
  
}

resource "kubernetes_service_account" "ingress_nginx_sa" {
  provider = kubernetes.eks
    metadata { 
        
        name = "nginx-ingress-serviceaccount"
        namespace = kubernetes_namespace.ingress_nginx.metadata[0].name


      
    }
  
}


# ClusterRole for permissions

resource "kubernetes_cluster_role" "nginx_ingress_cr" {
  provider = kubernetes.eks
    metadata {
      name = "nginx_ingress_cr"

    }
  rule {
    api_groups = [""]
    resources  = ["configmaps","endpoints","pods","secrets","services","events"]
    verbs      = ["get","list","watch","create","update","patch"]
  }

  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses","ingressclasses"]
    verbs      = ["get","list","watch","create","update","patch"]
  }


    rule {
      api_groups = [""]
      resources = ["nodes"]
      verbs = ["get","list","watch"]
    }
}

#ClusterRoleBinding

resource "kubernetes_cluster_role_binding" "nginx_ingress_crb" {
  provider = kubernetes.eks
    metadata {
      name = "nginx_ingress_crb"
    }
    role_ref { 
        api_group = "rbac.authorization.k8s.io"
        kind = "ClusterRole"
        name = kubernetes_cluster_role.nginx_ingress_cr.metadata[0].name
    }
    subject {
        kind = "ServiceAccount"
        name = kubernetes_service_account.ingress_nginx_sa.metadata[0].name
        namespace = kubernetes_namespace.ingress_nginx.metadata[0].name
    }
}

resource "kubernetes_deployment" "nginx_ingress_controller" {
  provider = kubernetes.eks

  metadata {
    name      = "nginx-ingress-controller"
    namespace = kubernetes_namespace.ingress_nginx.metadata[0].name
    labels = {
      app = "nginx-ingress"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "nginx-ingress"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx-ingress"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.ingress_nginx_sa.metadata[0].name

        container {
          name  = "nginx-ingress-controller"
          image = "registry.k8s.io/ingress-nginx/controller:v1.11.2"

          command = ["/nginx-ingress-controller"]

          args = [
            "--election-id=ingress-controller-leader",
            "--controller-class=k8s.io/ingress-nginx",
            "--publish-service=$(POD_NAMESPACE)/nginx-ingress-svc",
            "--ingress-class=nginx"
          ]

          port {
            name          = "http"
            container_port = 80
          }

          port {
            name          = "https"
            container_port = 443
          }

          # Fix missing environment variables
          env {
            name = "POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
        }
      }
    }
  }
}


# Service of type LoadBalancer

resource "kubernetes_service" "nginx_ingress_svc" {
  provider = kubernetes.eks
    metadata {
      name = "nginx-ingress-svc"
      namespace = kubernetes_namespace.ingress_nginx.metadata[0].name
      labels = {
        app = "nginx-ingress"
      }
    }
    spec {
      selector = {
        app = "nginx-ingress"
        }
        type = "LoadBalancer"
        port {
          name = "http"
          port = 80
          target_port = 80
        }
        port {
          name = "https"
          port = 443
          target_port = 443
        }
    }
    depends_on = [kubernetes_namespace.ingress_nginx]
  
}

