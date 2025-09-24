
output "KubeConfig" {
  value = module.ITR-oke.KubeConfig
}

output "Cluster" {
  value = module.ITR-oke.cluster
}

output "NodePool" {
  value = module.ITR-oke.node_pool
}


output "ClusterAddOns" {
  value = module.ITR-oke.oke_cluster_addons
}
