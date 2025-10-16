

resource "kubernetes_manifest" "cluster_issuer" {
  provider = kubernetes.eks
  
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind     = "ClusterIssuer"
    metadata = {
       name = "letsencrypt-staging" 
       }
    spec = {
      acme = {
        server = "https://acme-staging-v02.api.letsencrypt.org/directory"
        email  = "you@example.com"        
        privateKeySecretRef = {
           name = "letsencrypt-staging" 
           }
        solvers = [{
           http01 = {
             ingress = {
               class = "nginx" }}}]
      }
    }
  }
  depends_on = [kubernetes_namespace.cert_manager]
}