# Setup FSS on Webserver1

resource "null_resource" "Webserver1SharedFilesystem" {
  depends_on = [oci_core_instance.Webserver1, oci_core_instance.BastionServer, oci_file_storage_export.Export]

  provisioner "remote-exec" {
    connection {
      type                = "ssh"
      user                = "opc"
      host                = data.oci_core_vnic.Webserver1_VNIC1.private_ip_address
      private_key         = file("/home/ziad/Downloads/ssh-key-2024-09-02.key")
      script_path         = "/home/opc/myssh.sh"
      agent               = false
      timeout             = "10m"
      bastion_host        = data.oci_core_vnic.BastionServer_VNIC1.public_ip_address
      bastion_port        = "22"
      bastion_user        = "opc"
      bastion_private_key = file("/home/ziad/Downloads/ssh-key-2024-09-02.key")
    }
    inline = [
      "echo '== Start of null_resource.Webserver1SharedFilesystem'",
      "sudo /bin/su -c \"yum install -y -q nfs-utils\"",
      "sudo /bin/su -c \"mkdir -p /sharedfs\"",
      "sudo /bin/su -c \"echo '${var.MountTargetIPAddress}:/sharedfs /sharedfs nfs rsize=8192,wsize=8192,timeo=14,intr 0 0' >> /etc/fstab\"",
      "sudo /bin/su -c \"mount /sharedfs\"",
      "echo '== End of null_resource.Webserver2SharedFilesystem'"
    ]
  }

}

# Setup FSS on Webserver2

resource "null_resource" "Webserver2SharedFilesystem" {
  depends_on = [oci_core_instance.Webserver2, oci_core_instance.BastionServer, oci_file_storage_export.Export]

  provisioner "remote-exec" {
    connection {
      type                = "ssh"
      user                = "opc"
      host                = data.oci_core_vnic.Webserver2_VNIC1.private_ip_address
      private_key         = file("/home/ziad/Downloads/ssh-key-2024-09-02.key")
      script_path         = "/home/opc/myssh.sh"
      agent               = false
      timeout             = "10m"
      bastion_host        = data.oci_core_vnic.BastionServer_VNIC1.public_ip_address
      bastion_port        = "22"
      bastion_user        = "opc"
      bastion_private_key = file("/home/ziad/Downloads/ssh-key-2024-09-02.key")
    }
    inline = [
      "echo '== Start of null_resource.Webserver2SharedFilesystem'",
      "sudo /bin/su -c \"yum install -y -q nfs-utils\"",
      "sudo /bin/su -c \"mkdir -p /sharedfs\"",
      "sudo /bin/su -c \"echo '${var.MountTargetIPAddress}:/sharedfs /sharedfs nfs rsize=8192,wsize=8192,timeo=14,intr 0 0' >> /etc/fstab\"",
      "sudo /bin/su -c \"mount /sharedfs\"",
      "echo '== Start of null_resource.Webserver2SharedFilesystem'"
    ]
  }

}


# Software installation within WebServer1 Instance

resource "null_resource" "Webserver1HTTPD" {
  depends_on = [oci_core_instance.Webserver1, oci_core_instance.BastionServer, null_resource.Webserver1SharedFilesystem]
  provisioner "remote-exec" {
    connection {
      type                = "ssh"
      user                = "opc"
      host                = data.oci_core_vnic.Webserver1_VNIC1.private_ip_address
      private_key         = file("/home/ziad/Downloads/ssh-key-2024-09-02.key")
      script_path         = "/home/opc/myssh.sh"
      agent               = false
      timeout             = "10m"
      bastion_host        = data.oci_core_vnic.BastionServer_VNIC1.public_ip_address
      bastion_port        = "22"
      bastion_user        = "opc"
      bastion_private_key = file("/home/ziad/Downloads/ssh-key-2024-09-02.key")
    }
    inline = ["echo '== 1. Installing HTTPD package with yum'",
      "sudo -u root yum -y -q install httpd",

      "echo '== 2. Creating /sharedfs/index.html'",
      "sudo -u root touch /sharedfs/index.html",
      "sudo /bin/su -c \"echo 'Welcome to ITR.com! These are both WEBSERVERS under LB umbrella with shared index.html ...' > /sharedfs/index.html\"",

      "echo '== 3. Adding Alias and Directory sharedfs to /etc/httpd/conf/httpd.conf'",
      "sudo /bin/su -c \"echo 'Alias /shared/ /sharedfs/' >> /etc/httpd/conf/httpd.conf\"",
      "sudo /bin/su -c \"echo '<Directory /sharedfs>' >> /etc/httpd/conf/httpd.conf\"",
      "sudo /bin/su -c \"echo 'AllowOverride All' >> /etc/httpd/conf/httpd.conf\"",
      "sudo /bin/su -c \"echo 'Require all granted' >> /etc/httpd/conf/httpd.conf\"",
      "sudo /bin/su -c \"echo '</Directory>' >> /etc/httpd/conf/httpd.conf\"",

      "echo '== 4. Disabling SELinux'",
      "sudo -u root setenforce 0",

      "echo '== 5. Disabling firewall and starting HTTPD service'",
      "sudo -u root service firewalld stop",
    "sudo -u root service httpd start"]
  }
}

# Software installation within WebServer2 Instance

resource "null_resource" "Webserver2HTTPD" {
  depends_on = [null_resource.Webserver1HTTPD, oci_core_instance.Webserver2, oci_core_instance.BastionServer, null_resource.Webserver2SharedFilesystem]
  provisioner "remote-exec" {
    connection {
      type                = "ssh"
      user                = "opc"
      host                = data.oci_core_vnic.Webserver1_VNIC1.private_ip_address
      private_key         = file("/home/ziad/Downloads/ssh-key-2024-09-02.key") 
      script_path         = "/home/opc/myssh.sh"
      agent               = false
      timeout             = "10m"
      bastion_host        = data.oci_core_vnic.BastionServer_VNIC1.public_ip_address
      bastion_port        = "22"
      bastion_user        = "opc"
      bastion_private_key = file("/home/ziad/Downloads/ssh-key-2024-09-02.key")
    }
    inline = ["echo '== 1. Installing HTTPD package with yum'",
      "sudo -u root yum -y -q install httpd",

      "echo '== 2. Adding Alias and Directory sharedfs to /etc/httpd/conf/httpd.conf'",
      "sudo /bin/su -c \"echo 'Alias /shared/ /sharedfs/' >> /etc/httpd/conf/httpd.conf\"",
      "sudo /bin/su -c \"echo '<Directory /sharedfs>' >> /etc/httpd/conf/httpd.conf\"",
      "sudo /bin/su -c \"echo 'AllowOverride All' >> /etc/httpd/conf/httpd.conf\"",
      "sudo /bin/su -c \"echo 'Require all granted' >> /etc/httpd/conf/httpd.conf\"",
      "sudo /bin/su -c \"echo '</Directory>' >> /etc/httpd/conf/httpd.conf\"",

      "echo '== 3. Disabling SELinux'",
      "sudo -u root setenforce 0",

      "echo '== 4. Disabling firewall and starting HTTPD service'",
      "sudo -u root service firewalld stop",
    "sudo -u root service httpd start"]
  }
}
