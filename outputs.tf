output "alb_dns" {
  value = aws_lb.alb.dns_name
}
output "blue_cluster_name" {
  value = module.eks_blue.cluster_id
}
output "green_cluster_name" {
  value = module.eks_green.cluster_id
}
