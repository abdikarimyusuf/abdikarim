

provider "kubernetes" {
  alias = "eks"
  config_path    = "~/.kube/config"   # Path to your kubeconfig
  config_context = "arn:aws:eks:eu-west-2:533567531054:cluster/demo-eks-scratch"
}
