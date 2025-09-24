
# WebServer1 Instance Public IP
output "demotfWebserver1PublicIP" {
  value = [data.oci_core_vnic.demotfWebserver1_VNIC1.public_ip_address]
}

# WebServer2 Instance Public IP
output "demotfWebserver2PublicIP" {
  value = [data.oci_core_vnic.demotfWebserver2_VNIC1.public_ip_address]
}

# Generated Private Key for WebServer Instance
output "generated_ssh_private_key" {
  value     = tls_private_key.public_private_key_pair.private_key_pem
  sensitive = true
}