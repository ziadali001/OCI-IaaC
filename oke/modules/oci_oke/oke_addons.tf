resource "oci_containerengine_addon" "oke_addon" {
    for_each = local.oke_addon_map  
    addon_name = each.key
    cluster_id = oci_containerengine_cluster.oke_cluster.id

    dynamic "configurations" {
        for_each = each.value.configurations
        content {
           key = configurations.key
           value = configurations.value.config_value
        }
   }

    remove_addon_resources_on_delete = true 
    version = each.value.addon_version
}

resource "oci_containerengine_addon" "oke_autoscaler_addon" {
    count = var.virtual_node_pool ? 0 : var.autoscaler_enabled ? 1 : 0 
    addon_name = "ClusterAutoscaler"
    cluster_id = oci_containerengine_cluster.oke_cluster.id

    configurations {
      key = "nodes"
      value = join("", [var.autoscaler_min_number_of_nodes,":",var.autoscaler_max_number_of_nodes,":",oci_containerengine_node_pool.oke_autoscaler_node_pool[0].id])
    }

    configurations {
      key = "scaleDownDelayAfterAdd"
      value = var.autoscaler_scale_down_delay_after_add
    }
 
    configurations {
      key = "scaleDownUnneededTime"
      value = var.autoscaler_scale_down_unneeded_time
    }    

    dynamic "configurations" {
     for_each = var.autoscaler_authtype_workload ? [1] : []
       content {
       key = "authType"
       value = "workload"
     }
    }

    remove_addon_resources_on_delete = true
}