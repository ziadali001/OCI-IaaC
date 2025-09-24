# VCN
resource "oci_core_virtual_network" "VCN" {
  cidr_block     = var.VCN-CIDR
  dns_label      = "VCN"
  compartment_id = oci_identity_compartment.Terraform-Demo.id
  display_name   = "VCN"
}

# DHCP Options
resource "oci_core_dhcp_options" "DhcpOptions1" {
  compartment_id = oci_identity_compartment.Terraform-Demo.id
  vcn_id         = oci_core_virtual_network.VCN.id
  display_name   = "DHCPOptions1"

  options {
    type        = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }

  options {
    type                = "SearchDomain"
    search_domain_names = ["ITR.com"]
  }
}

# Internet Gateway
resource "oci_core_internet_gateway" "InternetGateway" {
  compartment_id = oci_identity_compartment.Terraform-Demo.id
  display_name   = "InternetGateway"
  vcn_id         = oci_core_virtual_network.VCN.id
}

# Route Table for IGW
resource "oci_core_route_table" "RouteTableViaIGW" {
  compartment_id = oci_identity_compartment.Terraform-Demo.id
  vcn_id         = oci_core_virtual_network.VCN.id
  display_name   = "RouteTableViaIGW"
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.InternetGateway.id
  }
}

# NAT Gateway
resource "oci_core_nat_gateway" "NATGateway" {
  compartment_id = oci_identity_compartment.Terraform-Demo.id
  display_name   = "NATGateway"
  vcn_id         = oci_core_virtual_network.VCN.id
}

# Route Table for NAT
resource "oci_core_route_table" "RouteTableViaNAT" {
  compartment_id = oci_identity_compartment.Terraform-Demo.id
  vcn_id         = oci_core_virtual_network.VCN.id
  display_name   = "RouteTableViaNAT"
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.NATGateway.id
  }
}

# Security List for HTTP/HTTPS
resource "oci_core_security_list" "WebSecurityList" {
  compartment_id = oci_identity_compartment.Terraform-Demo.id
  display_name   = "WebSecurityList"
  vcn_id         = oci_core_virtual_network.VCN.id

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  dynamic "ingress_security_rules" {
    for_each = var.webservice_ports
    content {
      protocol = "6"
      source   = "0.0.0.0/0"
      tcp_options {
        max = ingress_security_rules.value
        min = ingress_security_rules.value
      }
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = var.VCN-CIDR
  }
}

# Security List for SSH
resource "oci_core_security_list" "SSHSecurityList" {
  compartment_id = oci_identity_compartment.Terraform-Demo.id
  display_name   = "SSHSecurityList"
  vcn_id         = oci_core_virtual_network.VCN.id

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  dynamic "ingress_security_rules" {
    for_each = var.bastion_ports
    content {
      protocol = "6"
      source   = "0.0.0.0/0"
      tcp_options {
        max = ingress_security_rules.value
        min = ingress_security_rules.value
      }
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = var.VCN-CIDR
  }
}

# WebSubnet (private)
resource "oci_core_subnet" "WebSubnet" {
  cidr_block                 = var.WebSubnet-CIDR
  display_name               = "WebSubnet"
  dns_label                  = "ITRN2"
  compartment_id             = oci_identity_compartment.Terraform-Demo.id
  vcn_id                     = oci_core_virtual_network.VCN.id
  route_table_id             = oci_core_route_table.RouteTableViaNAT.id
  dhcp_options_id            = oci_core_dhcp_options.DhcpOptions1.id
  security_list_ids          = [oci_core_security_list.WebSecurityList.id, oci_core_security_list.SSHSecurityList.id]
  prohibit_public_ip_on_vnic = true
}

# LoadBalancer Subnet (public)
resource "oci_core_subnet" "LBSubnet" {
  cidr_block        = var.LBSubnet-CIDR
  display_name      = "LBSubnet"
  dns_label         = "ITRN1"
  compartment_id    = oci_identity_compartment.Terraform-Demo.id
  vcn_id            = oci_core_virtual_network.VCN.id
  route_table_id    = oci_core_route_table.RouteTableViaIGW.id
  dhcp_options_id   = oci_core_dhcp_options.DhcpOptions1.id
  security_list_ids = [oci_core_security_list.WebSecurityList.id]
}

# Bastion Subnet (public)
resource "oci_core_subnet" "BastionSubnet" {
  cidr_block        = var.BastionSubnet-CIDR
  display_name      = "BastionSubnet"
  dns_label         = "ITRN3"
  compartment_id    = oci_identity_compartment.Terraform-Demo.id
  vcn_id            = oci_core_virtual_network.VCN.id
  route_table_id    = oci_core_route_table.RouteTableViaIGW.id
  dhcp_options_id   = oci_core_dhcp_options.DhcpOptions1.id
  security_list_ids = [oci_core_security_list.SSHSecurityList.id]
}


