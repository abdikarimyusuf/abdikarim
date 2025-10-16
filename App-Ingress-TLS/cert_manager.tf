#resource "helm_release" "cert_manager" {
 #   name = "cert-manager"
  #  repository = "https://charts.jetstack.io"
   # chart = "cert-manager"

    #namespace = "cert-manager" #neighborhood
 #   create_namespace = true

  #  set {    #overrides a value in the Helm chart.
   #   name = "installCRDs"
    #  value = "true"
    #}}

    resource "kubernetes_namespace" "cert_manager" {
      provider = kubernetes.eks
      metadata {
        name = "cert-manager"
      }

      
    }
# Deploy cert-manager using manifests

resource "kubernetes_manifest" "cert_manager" {
  provider = kubernetes.eks


  manifest = {
    apiVersion = "apps/v1"
    kind = "Deployment"
    metadata = {
      name = "cert-manager"
      namespace = kubernetes_namespace.cert_manager.metadata[0].name
    }
    spec = {
      replicas = 1
      selector = {
        matchLabels = {
          app = "cert-manager"
        }
      }
      template = {
        metadata = {
          labels = { 
            app = "cert-manager"
            }
        }
        spec = {
          containers = [{
            name = "cert-manager"
            image = "quay.io/jetstack/cert-manager-controller:v1.14.0"
          }]
        }
      }
    }
  }
  
}
