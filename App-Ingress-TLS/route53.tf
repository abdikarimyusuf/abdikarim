#Route53 DNS record pointing your domain to the NGINX LoadBalancer

resource "aws_route53_record" "app_dns" {
  zone_id = "Z0988254P2F8HNJGBVII"
  name    = "abdikarim.co.uk"
  type    = "A"
  alias {
    name                   = kubernetes_service.nginx_ingress_svc.status[0].load_balancer[0].ingress[0].hostname
    zone_id                = "ZHURV8PSTC4K8"  # AWS global ELB hosted zone ID (for classic/ALB, varies by region)
    evaluate_target_health = true
  }
}

#a7c1d4426a34f4b0e8fe57b16383c37e-850648551.eu-west-2.elb.amazonaws.com