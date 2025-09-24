
# Bastion Instance Public IP
output "demotfBastionServer_PublicIP" {
  value = [data.oci_core_vnic.demotfBastionServer_VNIC1.public_ip_address]
}

# LoadBalancer Public IP
output "demotfPublicLoadBalancer_Public_IP" {
  value = [oci_load_balancer.demotfPublicLoadBalancer.ip_addresses]
}

# WebServer1 Instance Private IP
output "demotfWebserver1PrivateIP" {
  value = [data.oci_core_vnic.demotfWebserver1_VNIC1.private_ip_address]
}

# WebServer2 Instance Private IP
output "demotfWebserver2PrivateIP" {
  value = [data.oci_core_vnic.demotfWebserver2_VNIC1.private_ip_address]
}

/*
# Generated Private Key for WebServer Instance
output "generated_ssh_private_key" {
  value     = tls_private_key.public_private_key_pair.public_key_openssh
  sensitive = true
}
*/