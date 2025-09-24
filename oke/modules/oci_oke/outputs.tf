output "cluster" {
  value = {
    id                 = oci_containerengine_cluster.oke_cluster.id
    kubernetes_version = oci_containerengine_cluster.oke_cluster.kubernetes_version
    name               = oci_containerengine_cluster.oke_cluster.name
  }
}

output "node_pool" {
  value = {
    id                 = var.virtual_node_pool ? oci_containerengine_virtual_node_pool.oke_virtual_node_pool[*].id : oci_containerengine_node_pool.oke_node_pool[*].id
    kubernetes_version = var.virtual_node_pool ? oci_containerengine_virtual_node_pool.oke_virtual_node_pool[*].kubernetes_version : oci_containerengine_node_pool.oke_node_pool[*].kubernetes_version
    name               = var.virtual_node_pool ? oci_containerengine_virtual_node_pool.oke_virtual_node_pool[*].display_name : oci_containerengine_node_pool.oke_node_pool[*].name
    nodes              = var.virtual_node_pool ? null : oci_containerengine_node_pool.oke_node_pool[*].nodes[*].private_ip
  }
}


output "chosen_node_shape_and_image" {
  value = {
    image_id = (
      length([for source in data.oci_containerengine_node_pool_option.oke_node_pool_option.sources : source.image_id if length(regexall("Oracle-Linux-${var.node_linux_version}-20[0-9]*.*", source.source_name)) > 0]) > 0
      ? element([for source in data.oci_containerengine_node_pool_option.oke_node_pool_option.sources : source.image_id if length(regexall("Oracle-Linux-${var.node_linux_version}-20[0-9]*.*", source.source_name)) > 0], 0)
      : null
    )
    source_name = (
      length([for source in data.oci_containerengine_node_pool_option.oke_node_pool_option.sources : source.source_name if length(regexall("Oracle-Linux-${var.node_linux_version}-20[0-9]*.*", source.source_name)) > 0]) > 0
      ? element([for source in data.oci_containerengine_node_pool_option.oke_node_pool_option.sources : source.source_name if length(regexall("Oracle-Linux-${var.node_linux_version}-20[0-9]*.*", source.source_name)) > 0], 0)
      : null
    )
  }
}




output "KubeConfig" {
  value = data.oci_containerengine_cluster_kube_config.KubeConfig.content
}

output "oke_cluster_addons" {
  value = data.oci_containerengine_addons.oke_cluster_addons
}

output "oke_addon_options" {
  value = data.oci_containerengine_addon_options.oke_addon_options
}