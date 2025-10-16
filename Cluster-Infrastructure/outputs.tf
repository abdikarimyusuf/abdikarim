 output "cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "cluster_kubeconfig_certificate" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

#Z0988254P2F8HNJGBVII
#-lock=false 
