
# WebServer Compute

resource "oci_core_instance" "demotfWebserver1" {
  availability_domain = var.availablity_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availablity_domain_name
  compartment_id      = var.compartment_ocid
  display_name        = "demotfWebServer"
  shape               = var.Shape

  dynamic "shape_config" {
    for_each = local.is_flexible_shape ? [1] : []
    content {
      memory_in_gbs = var.FlexShapeMemory
      ocpus         = var.FlexShapeOCPUS
    }
  }

  fault_domain = "FAULT-DOMAIN-1"
  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.OSImage.images[0], "id")
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.ssh_key.public_key_openssh
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.demotfWebSubnet.id
    assign_public_ip = true
  }
}


# WebServer2 Compute

resource "oci_core_instance" "demotfWebServer2" {
  availability_domain = var.availablity_domain_name2 == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availablity_domain_name2
  compartment_id      = var.compartment_ocid
  display_name        = "demotfWebServer2"
  shape               = var.Shape
  dynamic "shape_config" {
    for_each = local.is_flexible_shape ? [1] : []
    content {
      memory_in_gbs = var.FlexShapeMemory
      ocpus         = var.FlexShapeOCPUS
    }
  }

  fault_domain = "FAULT-DOMAIN-1"
  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.OSImage.images[0], "id")
  }
  metadata = {
    ssh_authorized_keys = tls_private_key.ssh_key.public_key_openssh
  }
  create_vnic_details {
    subnet_id        = oci_core_subnet.demotfWebSubnet.id
    assign_public_ip = true
  }
}
