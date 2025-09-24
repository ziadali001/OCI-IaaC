# VCN
resource "oci_core_virtual_network" "demotfVCN" {
  cidr_block     = var.VCN-CIDR
  dns_label      = "demotfVCN"
  compartment_id = oci_identity_compartment.DemoTF-Compartment.id
  display_name   = "demotfVCN"
}

# DHCP Options
resource "oci_core_dhcp_options" "demotfDhcpOptions1" {
  compartment_id = oci_identity_compartment.DemoTF-Compartment.id
  vcn_id         = oci_core_virtual_network.demotfVCN.id
  display_name   = "demotfDHCPOptions1"

  options {
    type        = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }

  options {
    type                = "SearchDomain"
    search_domain_names = ["demotf.com"]
  }
}

# Internet Gateway
resource "oci_core_internet_gateway" "demotfInternetGateway" {
  compartment_id = oci_identity_compartment.DemoTF-Compartment.id
  display_name   = "demotfInternetGateway"
  vcn_id         = oci_core_virtual_network.demotfVCN.id
}

# Route Table for IGW
resource "oci_core_route_table" "demotfRouteTableViaIGW" {
  compartment_id = oci_identity_compartment.DemoTF-Compartment.id
  vcn_id         = oci_core_virtual_network.demotfVCN.id
  display_name   = "demotfRouteTableViaIGW"
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.demotfInternetGateway.id
  }
}

# NAT Gateway
resource "oci_core_nat_gateway" "demotfNATGateway" {
  compartment_id = oci_identity_compartment.DemoTF-Compartment.id
  display_name   = "demotfNATGateway"
  vcn_id         = oci_core_virtual_network.demotfVCN.id
}

# Route Table for NAT
resource "oci_core_route_table" "demotfRouteTableViaNAT" {
  compartment_id = oci_identity_compartment.DemoTF-Compartment.id
  vcn_id         = oci_core_virtual_network.demotfVCN.id
  display_name   = "demotfRouteTableViaNAT"
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.demotfNATGateway.id
  }
}

# WebSubnet (private)
resource "oci_core_subnet" "demotfWebSubnet" {
  cidr_block                 = var.WebSubnet-CIDR
  display_name               = "demotfWebSubnet"
  dns_label                  = "demotfN1"
  compartment_id             = oci_identity_compartment.DemoTF-Compartment.id
  vcn_id                     = oci_core_virtual_network.demotfVCN.id
  route_table_id             = oci_core_route_table.demotfRouteTableViaNAT.id
  dhcp_options_id            = oci_core_dhcp_options.demotfDhcpOptions1.id
  prohibit_public_ip_on_vnic = true
}

# LoadBalancer Subnet (public)
resource "oci_core_subnet" "demotfLBSubnet" {
  cidr_block        = var.LBSubnet-CIDR
  display_name      = "demotfLBSubnet"
  dns_label         = "demotfN2"
  compartment_id    = oci_identity_compartment.DemoTF-Compartment.id
  vcn_id            = oci_core_virtual_network.demotfVCN.id
  route_table_id    = oci_core_route_table.demotfRouteTableViaIGW.id
  dhcp_options_id   = oci_core_dhcp_options.demotfDhcpOptions1.id
}

# Bastion Subnet (public)
resource "oci_core_subnet" "demotfBastionSubnet" {
  cidr_block        = var.BastionSubnet-CIDR
  display_name      = "demotfBastionSubnet"
  dns_label         = "demotfN3"
  compartment_id    = oci_identity_compartment.DemoTF-Compartment.id
  vcn_id            = oci_core_virtual_network.demotfVCN.id
  route_table_id    = oci_core_route_table.demotfRouteTableViaIGW.id
  dhcp_options_id   = oci_core_dhcp_options.demotfDhcpOptions1.id
}



