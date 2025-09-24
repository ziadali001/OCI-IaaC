# Setup FSS on Webserver1

resource "null_resource" "Webserver1SharedFilesystem" {
  depends_on = [oci_core_instance.Webserver1, oci_core_instance.BastionServer, oci_file_storage_export.Export]

  provisioner "remote-exec" {
    connection {
      type                = "ssh"
      user                = "opc"
      host                = data.oci_core_vnic.Webserver1_VNIC1.private_ip_address
      private_key         = tls_private_key.ssh_key.private_key_pem
      script_path         = "/home/opc/myssh.sh"
      agent               = false
      timeout             = "10m"
      bastion_host        = data.oci_core_vnic.BastionServer_VNIC1.public_ip_address
      bastion_port        = "22"
      bastion_user        = "opc"
      bastion_private_key = tls_private_key.ssh_key.private_key_pem
    }
    inline = [
      "echo '== Start of null_resource.Webserver1SharedFilesystem'",
      "sudo /bin/su -c \"yum install -y -q nfs-utils\"",
      "sudo /bin/su -c \"mkdir -p /sharedfs\"",
      "sudo /bin/su -c \"echo '${var.MountTargetIPAddress}:/sharedfs /sharedfs nfs rsize=8192,wsize=8192,timeo=14,intr 0 0' >> /etc/fstab\"",
      "sudo /bin/su -c \"mount /sharedfs\"",
      "echo '== End of null_resource.Webserver1SharedFilesystem'"
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
      private_key         = tls_private_key.ssh_key.private_key_pem
      script_path         = "/home/opc/myssh.sh"
      agent               = false
      timeout             = "10m"
      bastion_host        = data.oci_core_vnic.BastionServer_VNIC1.public_ip_address
      bastion_port        = "22"
      bastion_user        = "opc"
      bastion_private_key = tls_private_key.ssh_key.private_key_pem
    }
    inline = [
      "echo '== Start of null_resource.Webserver2SharedFilesystem'",
      "sudo /bin/su -c \"yum install -y -q nfs-utils\"",
      "sudo /bin/su -c \"mkdir -p /sharedfs\"",
      "sudo /bin/su -c \"echo '${var.MountTargetIPAddress}:/sharedfs /sharedfs nfs rsize=8192,wsize=8192,timeo=14,intr 0 0' >> /etc/fstab\"",
      "sudo /bin/su -c \"mount /sharedfs\"",
      "echo '== End of null_resource.Webserver2SharedFilesystem'"
    ]
  }

}

/*
# Software installation within WebServer1 Instance

resource "null_resource" "Webserver1HTTPD" {
  depends_on = [oci_core_instance.Webserver1, oci_core_instance.BastionServer, null_resource.Webserver1SharedFilesystem]
  provisioner "remote-exec" {
    connection {
      type                = "ssh"
      user                = "opc"
      host                = data.oci_core_vnic.Webserver1_VNIC1.private_ip_address
      private_key         = tls_private_key.ssh_key.private_key_pem
      script_path         = "/home/opc/myssh.sh"
      agent               = false
      timeout             = "10m"
      bastion_host        = data.oci_core_vnic.BastionServer_VNIC1.public_ip_address
      bastion_port        = "22"
      bastion_user        = "opc"
      bastion_private_key = tls_private_key.ssh_key.private_key_pem
    }
    inline = ["echo '== 1. Installing HTTPD package with yum'",
      "sudo -u root yum -y -q install httpd",

      "echo '== 2. Creating /sharedfs/index.html'",
      "sudo -u root touch /sharedfs/index.html",
      "sudo /bin/su -c \"echo 'Welcome to .com! These are both WEBSERVERS under LB umbrella with shared index.html ...' > /sharedfs/index.html\"",

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
  depends_on = [oci_core_instance.Webserver2, oci_core_instance.BastionServer, null_resource.Webserver2SharedFilesystem]
  provisioner "remote-exec" {
    connection {
      type                = "ssh"
      user                = "opc"
      host                = data.oci_core_vnic.Webserver2_VNIC1.private_ip_address
      private_key         = tls_private_key.ssh_key.private_key_pem
      script_path         = "/home/opc/myssh.sh"
      agent               = false
      timeout             = "10m"
      bastion_host        = data.oci_core_vnic.BastionServer_VNIC1.public_ip_address
      bastion_port        = "22"
      bastion_user        = "opc"
      bastion_private_key = tls_private_key.ssh_key.private_key_pem
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
*/


# Attachment of block volume to Webserver1
resource "null_resource" "Webserver1_oci_iscsi_attach" {
  depends_on = [oci_core_volume_attachment.Webserver1BlockVolume100G_attach]

  provisioner "remote-exec" {
    connection {
      type                = "ssh"
      user                = "opc"
      host                = data.oci_core_vnic.Webserver1_VNIC1.private_ip_address
      private_key         = tls_private_key.ssh_key.private_key_pem 
      script_path         = "/home/opc/myssh.sh"
      agent               = false
      timeout             = "10m"
      bastion_host        = data.oci_core_vnic.BastionServer_VNIC1.public_ip_address
      bastion_port        = "22"
      bastion_user        = "opc"
      bastion_private_key = tls_private_key.ssh_key.private_key_pem
    }
    inline = ["sudo /bin/su -c \"rm -Rf /home/opc/iscsiattach.sh\""]
  }

  provisioner "file" {
    connection {
      type                = "ssh"
      user                = "opc"
      host                = data.oci_core_vnic.Webserver1_VNIC1.private_ip_address
      private_key         = tls_private_key.ssh_key.private_key_pem 
      script_path         = "/home/opc/myssh.sh"
      agent               = false
      timeout             = "10m"
      bastion_host        = data.oci_core_vnic.BastionServer_VNIC1.public_ip_address
      bastion_port        = "22"
      bastion_user        = "opc"
      bastion_private_key = tls_private_key.ssh_key.private_key_pem
    }
    source      = "iscsiattach.sh"
    destination = "/home/opc/iscsiattach.sh"
  }

  provisioner "remote-exec" {
    connection {
      type                = "ssh"
      user                = "opc"
      host                = data.oci_core_vnic.Webserver1_VNIC1.private_ip_address
      private_key         = tls_private_key.ssh_key.private_key_pem 
      script_path         = "/home/opc/myssh.sh"
      agent               = false
      timeout             = "10m"
      bastion_host        = data.oci_core_vnic.BastionServer_VNIC1.public_ip_address
      bastion_port        = "22"
      bastion_user        = "opc"
      bastion_private_key = tls_private_key.ssh_key.private_key_pem
    }
    inline = ["sudo /bin/su -c \"chown root /home/opc/iscsiattach.sh\"",
      "sudo /bin/su -c \"chmod u+x /home/opc/iscsiattach.sh\"",
    "sudo /bin/su -c \"/home/opc/iscsiattach.sh\""]
  }

}

# Mount of attached block volume on Webserver1
resource "null_resource" "Webserver1_oci_u01_fstab" {
  depends_on = [null_resource.Webserver1_oci_iscsi_attach]

  provisioner "remote-exec" {
    connection {
      type                = "ssh"
      user                = "opc"
      host                = data.oci_core_vnic.Webserver1_VNIC1.private_ip_address
      private_key         = tls_private_key.ssh_key.private_key_pem 
      script_path         = "/home/opc/myssh.sh"
      agent               = false
      timeout             = "10m"
      bastion_host        = data.oci_core_vnic.BastionServer_VNIC1.public_ip_address
      bastion_port        = "22"
      bastion_user        = "opc"
      bastion_private_key = tls_private_key.ssh_key.private_key_pem
    }
    inline = ["echo '== Start of null_resource.Webserver1_oci_u01_fstab'",
      "sudo -u root parted /dev/sdb --script -- mklabel gpt",
      "sudo -u root parted /dev/sdb --script -- mkpart primary ext4 0% 100%",
      "sudo -u root mkfs.ext4 -F /dev/sdb1",
      "sudo -u root mkdir /u01",
      "sudo -u root mount /dev/sdb1 /u01",
      "sudo /bin/su -c \"echo '/dev/sdb1              /u01  ext4    defaults,noatime,_netdev    0   0' >> /etc/fstab\"",
      "sudo -u root mount | grep sdb1",
      "echo '== End of null_resource.Webserver1_oci_u01_fstab'",
    ]
  }

}