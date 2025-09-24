
# Web NSG
resource "oci_core_network_security_group" "demotfWebSecurityGroup" {
  compartment_id = oci_identity_compartment.DemoTF-Compartment.id
  display_name   = "demotfWebSecurityGroup"
  vcn_id         = oci_core_virtual_network.demotfVCN.id
}

# Web NSG Egress Rules
resource "oci_core_network_security_group_security_rule" "demotfWebSecurityEgressGroupRule" {
  network_security_group_id = oci_core_network_security_group.demotfWebSecurityGroup.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
}

# Web NSG Ingress Rules
resource "oci_core_network_security_group_security_rule" "demotfWebSecurityIngressGroupRules" {
  for_each = toset(var.webservice_ports)

  network_security_group_id = oci_core_network_security_group.demotfWebSecurityGroup.id
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
resource "oci_core_network_security_group" "demotfSSHSecurityGroup" {
  compartment_id = oci_identity_compartment.DemoTF-Compartment.id
  display_name   = "demotfSSHSecurityGroup"
  vcn_id         = oci_core_virtual_network.demotfVCN.id
}

# SSH NSG Egress Rules
resource "oci_core_network_security_group_security_rule" "demotfSSHSecurityEgressGroupRule" {
  network_security_group_id = oci_core_network_security_group.demotfSSHSecurityGroup.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
}

# SSH NSG Ingress Rules
resource "oci_core_network_security_group_security_rule" "demotfSSHSecurityIngressGroupRules" {
  for_each = toset(var.bastion_ports)

  network_security_group_id = oci_core_network_security_group.demotfSSHSecurityGroup.id
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
