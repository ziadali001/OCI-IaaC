
# Software installation within WebServer1 Instance

resource "null_resource" "demotfWebserver1HTTPD" {
  depends_on = [oci_core_instance.demotfWebserver1, oci_core_instance.demotfBastionServer]
  provisioner "remote-exec" {
    connection {
      type                = "ssh"
      user                = "opc"
      host                = data.oci_core_vnic.demotfWebserver1_VNIC1.private_ip_address
      private_key         = tls_private_key.public_private_key_pair.private_key_pem
      script_path         = "/home/opc/myssh.sh"
      agent               = false
      timeout             = "10m"
      bastion_host        = data.oci_core_vnic.demotfBastionServer_VNIC1.public_ip_address
      bastion_port        = "22"
      bastion_user        = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
    inline = ["echo '== 1. Installing HTTPD package with yum'",
      "sudo -u root yum -y -q install httpd",

      "echo '== 2. Creating /var/www/html/index.html'",
      "sudo -u root touch /var/www/html/index.html",
      "sudo /bin/su -c \"echo 'Welcome to ITR-Technology.com! This is WEBSERVER1...' > /var/www/html/index.html\"",

      "echo '== 3. Disabling firewall and starting HTTPD service'",
      "sudo -u root service firewalld stop",
    "sudo -u root service httpd start"]
  }
}

# Software installation within WebServer2 Instance

resource "null_resource" "demotfWebserver2HTTPD" {
  depends_on = [oci_core_instance.demotfWebserver2, oci_core_instance.demotfBastionServer]
  provisioner "remote-exec" {
    connection {
      type                = "ssh"
      user                = "opc"
      host                = data.oci_core_vnic.demotfWebserver2_VNIC1.private_ip_address
      private_key         = tls_private_key.public_private_key_pair.private_key_pem
      script_path         = "/home/opc/myssh.sh"
      agent               = false
      timeout             = "10m"
      bastion_host        = data.oci_core_vnic.demotfBastionServer_VNIC1.public_ip_address
      bastion_port        = "22"
      bastion_user        = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
    inline = ["echo '== 1. Installing HTTPD package with yum'",
      "sudo -u root yum -y -q install httpd",

      "echo '== 2. Creating /var/www/html/index.html'",
      "sudo -u root touch /var/www/html/index.html",
      "sudo /bin/su -c \"echo 'Welcome to ITR-Technology.com! This is WEBSERVER2...' > /var/www/html/index.html\"",

      "echo '== 3. Disabling firewall and starting HTTPD service'",
      "sudo -u root service firewalld stop",
    "sudo -u root service httpd start"]
  }
}
