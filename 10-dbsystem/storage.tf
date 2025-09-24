# Mount Target

resource "oci_file_storage_mount_target" "MountTarget" {
  availability_domain = var.availablity_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availablity_domain_name
  compartment_id      = oci_identity_compartment.Terraform-Demo.id
  subnet_id           = oci_core_subnet.WebSubnet.id
  ip_address          = var.MountTargetIPAddress
  display_name        = "MountTarget"
}

# Export Set

resource "oci_file_storage_export_set" "Exportset" {
  mount_target_id = oci_file_storage_mount_target.MountTarget.id
  display_name    = "Exportset"
}

# FileSystem

resource "oci_file_storage_file_system" "Filesystem" {
  availability_domain = var.availablity_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availablity_domain_name
  compartment_id      = oci_identity_compartment.Terraform-Demo.id
  display_name        = "Filesystem"
}

# Export

resource "oci_file_storage_export" "Export" {
  export_set_id  = oci_file_storage_mount_target.MountTarget.export_set_id
  file_system_id = oci_file_storage_file_system.Filesystem.id
  path           = "/sharedfs"
}

# 100 GB Block Volume
resource "oci_core_volume" "Webserver1BlockVolume100G" {
  availability_domain = var.availablity_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availablity_domain_name
  compartment_id      = oci_identity_compartment.Terraform-Demo.id
  display_name        = "Webserver1 BlockVolume 100G"
  size_in_gbs         = var.volume_size_in_gbs
}

# Attachment of 100 GB Block Volume to Webserver1
resource "oci_core_volume_attachment" "Webserver1BlockVolume100G_attach" {
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.Webserver1.id
  volume_id       = oci_core_volume.Webserver1BlockVolume100G.id
}

