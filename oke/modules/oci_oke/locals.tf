locals {
  availability_domains       = var.availability_domain == "" ? data.oci_identity_availability_domains.ADs.availability_domains : data.oci_identity_availability_domains.AD.availability_domains
  node_pool_image_ids        = data.oci_containerengine_node_pool_option.oke_node_pool_option.sources
  
  oke_specific_image_id = (
  var.node_pool_image_type == "oke" && length(regexall("GPU|A1", var.node_shape)) == 0
  ? (
    length([for source in local.node_pool_image_ids : source.image_id if length(regexall("Oracle-Linux-${var.node_linux_version}-20[0-9]*.*-OKE-${local.k8s_version_only}", source.source_name)) > 0]) > 0
    ? element([for source in local.node_pool_image_ids : source.image_id if length(regexall("Oracle-Linux-${var.node_linux_version}-20[0-9]*.*-OKE-${local.k8s_version_only}", source.source_name)) > 0], 0)
    : null
  ) : (
    var.node_pool_image_type == "oke" && length(regexall("GPU", var.node_shape)) > 0
    ? (
      length([for source in local.node_pool_image_ids : source.image_id if length(regexall("Oracle-Linux-${var.node_linux_version}-Gen[0-9]-GPU-20[0-9]*.*-OKE-${local.k8s_version_only}", source.source_name)) > 0]) > 0
      ? element([for source in local.node_pool_image_ids : source.image_id if length(regexall("Oracle-Linux-${var.node_linux_version}-Gen[0-9]-GPU-20[0-9]*.*-OKE-${local.k8s_version_only}", source.source_name)) > 0], 0)
      : null
    ) : (
      var.node_pool_image_type == "oke" && length(regexall("A1", var.node_shape)) > 0
      ? (
        length([for source in local.node_pool_image_ids : source.image_id if length(regexall("Oracle-Linux-${var.node_linux_version}-aarch64-20[0-9]*.*-OKE-${local.k8s_version_only}", source.source_name)) > 0]) > 0
        ? element([for source in local.node_pool_image_ids : source.image_id if length(regexall("Oracle-Linux-${var.node_linux_version}-aarch64-20[0-9]*.*-OKE-${local.k8s_version_only}", source.source_name)) > 0], 0)
        : null
      ) : null
    )
  )
)

  oci_platform_image_id      = (var.node_pool_image_type == "platform" && length(regexall("GPU|A1", var.node_shape)) == 0) ? (element([for source in local.node_pool_image_ids : source.image_id if length(regexall("^(Oracle-Linux-${var.node_linux_version}-\\d{4}.\\d{2}.\\d{2}-[0-9]*)$", source.source_name)) > 0], 0)) : (var.node_pool_image_type == "platform" && length(regexall("GPU", var.node_shape)) > 0) ? (element([for source in local.node_pool_image_ids : source.image_id if length(regexall("^(Oracle-Linux-${var.node_linux_version}-Gen[0-9]-GPU-\\d{4}.\\d{2}.\\d{2}-[0-9]*)$", source.source_name)) > 0], 0)) : (var.node_pool_image_type == "platform" && length(regexall("A1", var.node_shape)) > 0) ? (element([for source in local.node_pool_image_ids : source.image_id if length(regexall("^(Oracle-Linux-${var.node_linux_version}-aarch64-\\d{4}.\\d{2}.\\d{2}-[0-9]*)$", source.source_name)) > 0], 0)) : null
  k8s_version_length         = length(var.k8s_version)
  k8s_version_only           = substr(var.k8s_version,1,local.k8s_version_length)
  oke_addon_map              = var.cluster_type == "enhanced" ? var.oke_addon_map : {}
}


