
# WebServer Instance Public IP
output "VM1PublicIP" {
  value = [data.oci_core_vnic.VM_VNIC1.public_ip_address]
}

# Generated Private Key for WebServer Instance
output "generated_ssh_private_key" {
  value     = tls_private_key.ssh_key.public_key_openssh
  sensitive = true
}