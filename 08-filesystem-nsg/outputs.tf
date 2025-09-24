# Bastion Instance Public IP
output "BastionServer_PublicIP" {
  value = [data.oci_core_vnic.BastionServer_VNIC1.public_ip_address]
}


# LoadBalancer URL
output "PublicLoadBalancer_URL" {
  value = "http://${oci_load_balancer.PublicLoadBalancer.ip_addresses[0]}/shared/"
}


# WebServer1 Instance Private IP
output "Webserver1PrivateIP" {
  value = [data.oci_core_vnic.Webserver1_VNIC1.private_ip_address]
}


# WebServer2 Instance Private IP
output "Webserver2PrivateIP" {
  value = [data.oci_core_vnic.Webserver2_VNIC1.private_ip_address]
}

/*
# Generated Private Key for WebServer Instance
output "generated_ssh_private_key" {
  value     = tls_private_key.ssh_key.public_key_openssh
  sensitive = true
}
*/
