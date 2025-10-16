# Ingress with TLS via cert-manager
resource "kubernetes_ingress_v1" "name" {
  provider = kubernetes.eks
    metadata {
      name = "sample-app-ingress"
      namespace = "default"
      annotations = {
        "kubernetes.io/ingress.class"  = "nginx"
        "cert-manager.io/cluster_issuer" = "letsencrypt-staging"
      }
    }
  spec {
    tls {
        hosts = ["app.example.com"]
        secret_name = "sample-app-tls"
    }
    rule {
        host = "app.example.com"
        http {
          path {
            path = "/"
            path_type = "Prefix"
            backend {
              service {
                name = kubernetes_deployment.sample-app.metadata[0].name
                port {
                  number = 80
                }
              }
            }
          }
        }
    }
  }
  depends_on = [
    kubernetes_deployment.sample-app,
    kubernetes_deployment.nginx_ingress_controller
  ]
}