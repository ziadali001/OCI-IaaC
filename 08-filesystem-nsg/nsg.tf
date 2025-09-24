
# Web NSG
resource "oci_core_network_security_group" "WebSecurityGroup" {
  compartment_id = oci_identity_compartment.DemoTF-Compartment.id
  display_name   = "WebSecurityGroup"
  vcn_id         = oci_core_virtual_network.VCN.id
}

# Web NSG Egress Rules
resource "oci_core_network_security_group_security_rule" "WebSecurityEgressGroupRule" {
  network_security_group_id = oci_core_network_security_group.WebSecurityGroup.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
}

# Web NSG Ingress Rules
resource "oci_core_network_security_group_security_rule" "WebSecurityIngressGroupRules" {
  for_each = toset(var.webservice_ports)

  network_security_group_id = oci_core_network_security_group.WebSecurityGroup.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      max = each.value
      min = each.value
    }
  }
}

# SSH NSG
resource "oci_core_network_security_group" "SSHSecurityGroup" {
  compartment_id = oci_identity_compartment.DemoTF-Compartment.id
  display_name   = "SSHSecurityGroup"
  vcn_id         = oci_core_virtual_network.VCN.id
}

# SSH NSG Egress Rules
resource "oci_core_network_security_group_security_rule" "SSHSecurityEgressGroupRule" {
  network_security_group_id = oci_core_network_security_group.SSHSecurityGroup.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
}

# SSH NSG Ingress Rules
resource "oci_core_network_security_group_security_rule" "SSHSecurityIngressGroupRules" {
  for_each = toset(var.bastion_ports)

  network_security_group_id = oci_core_network_security_group.SSHSecurityGroup.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      max = each.value
      min = each.value
    }
  }
}

# FSS NSG
resource "oci_core_network_security_group" "FSSSecurityGroup" {
  compartment_id = oci_identity_compartment.DemoTF-Compartment.id
  display_name   = "FSSSecurityGroup"
  vcn_id         = oci_core_virtual_network.VCN.id
}

# FSS NSG Ingress TCP Rules
resource "oci_core_network_security_group_security_rule" "FSSSecurityIngressTCPGroupRules" {
  for_each = toset(var.fss_ingress_tcp_ports)

  network_security_group_id = oci_core_network_security_group.FSSSecurityGroup.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = var.WebSubnet-CIDR
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      max = each.value
      min = each.value
    }
  }
}

# FSS NSG Ingress UDP Rules
resource "oci_core_network_security_group_security_rule" "FSSSecurityIngressUDPGroupRules" {
  for_each = toset(var.fss_ingress_udp_ports)

  network_security_group_id = oci_core_network_security_group.FSSSecurityGroup.id
  direction                 = "INGRESS"
  protocol                  = "17"
  source                    = var.WebSubnet-CIDR
  source_type               = "CIDR_BLOCK"
  udp_options {
    destination_port_range {
      max = each.value
      min = each.value
    }
  }
}

# FSS NSG Egress TCP Rules
resource "oci_core_network_security_group_security_rule" "FSSSecurityEgressTCPGroupRules" {
  for_each = toset(var.fss_egress_tcp_ports)

  network_security_group_id = oci_core_network_security_group.FSSSecurityGroup.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = var.WebSubnet-CIDR
  destination_type          = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      max = each.value
      min = each.value
    }
  }
}

# FSS NSG Egress UDP Rules
resource "oci_core_network_security_group_security_rule" "FSSSecurityEgressUDPGroupRules" {
  for_each = toset(var.fss_egress_udp_ports)

  network_security_group_id = oci_core_network_security_group.FSSSecurityGroup.id
  direction                 = "EGRESS"
  protocol                  = "17"
  destination               = var.WebSubnet-CIDR
  destination_type          = "CIDR_BLOCK"
  udp_options {
    destination_port_range {
      max = each.value
      min = each.value
    }
  }
}