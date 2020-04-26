output "cluster_id" {
  description = "List of IDs of instances"
  value       = module.ecs.cluster.id
}

output "cluster_name" {
  description = "ECS Cluster name"
  value       = module.ecs.cluster_name.name
}

