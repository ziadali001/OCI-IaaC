# Bastion Compute

resource "oci_core_instance" "BastionServer" {
  availability_domain = var.availablity_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availablity_domain_name
  compartment_id      = oci_identity_compartment.DemoTF-Compartment.id
  display_name        = "BastionServer"
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
    ssh_authorized_keys = file("/home/ziad/Downloads/ssh-key-2024-09-02.key.pub")
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.BastionSubnet.id
    assign_public_ip = true
    nsg_ids          = [oci_core_network_security_group.SSHSecurityGroup.id]
  }
}

# WebServer1 Compute

resource "oci_core_instance" "Webserver1" {
  availability_domain = var.availablity_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availablity_domain_name
  compartment_id      = oci_identity_compartment.DemoTF-Compartment.id
  display_name        = "WebServer1"
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
    ssh_authorized_keys = file("/home/ziad/Downloads/ssh-key-2024-09-02.key.pub")
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.WebSubnet.id
    assign_public_ip = false
    nsg_ids          = [oci_core_network_security_group.SSHSecurityGroup.id, oci_core_network_security_group.WebSecurityGroup.id]
  }
}

# WebServer2 Compute

resource "oci_core_instance" "Webserver2" {
  availability_domain = var.availablity_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availablity_domain_name
  compartment_id      = oci_identity_compartment.DemoTF-Compartment.id
  display_name        = "WebServer2"
  shape               = var.Shape
  dynamic "shape_config" {
    for_each = local.is_flexible_shape ? [1] : []
    content {
      memory_in_gbs = var.FlexShapeMemory
      ocpus         = var.FlexShapeOCPUS
    }
  }

  fault_domain = "FAULT-DOMAIN-2"
  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.OSImage.images[0], "id")
  }
 
  metadata = {
    ssh_authorized_keys = file("/home/ziad/Downloads/ssh-key-2024-09-02.key.pub")
  }
  
  create_vnic_details {
    subnet_id        = oci_core_subnet.WebSubnet.id
    assign_public_ip = false
    nsg_ids          = [oci_core_network_security_group.SSHSecurityGroup.id, oci_core_network_security_group.WebSecurityGroup.id]

  }
}