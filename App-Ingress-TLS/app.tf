# Sample App Deployment

resource "kubernetes_deployment" "sample-app" {
  provider = kubernetes.eks
    metadata {
      name = "sample-app"
      namespace = "default"
      labels    = {
         app = "sample-app" 
         }
    }

    spec {
      replicas = 2
      selector {
        match_labels = {
            app = "sample-app"
        }
      }
      template {
        metadata {
          labels = {
             app = "sample-app" 
             } 
          
          }
          spec {
            container {
              name = "nginx"
              image = "nginx:stable"
              port {
                container_port = 80
              }
            }
          }
        }
        
    
}

# ClusterIP Service
}

resource "kubernetes_service" "sample-app-svc" {
  provider = kubernetes.eks
    metadata {
      name = "sample-app-svc"
      namespace = "default"
       }
       spec {
        selector = { 
            app = "sample-app"
             }
        port {
          port = 80
          target_port = 80
        }
        type = "ClusterIP"
         
       }
  
}

