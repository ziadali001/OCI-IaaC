
# VCN
resource "oci_core_virtual_network" "demotfVCN" {
  cidr_block     = var.VCN-CIDR
  dns_label      = "demotfVCN"
  compartment_id =   var.compartment_ocid

  display_name   = "demotfVCN"
}

# DHCP Options
resource "oci_core_dhcp_options" "demotfDhcpOptions1" {
  compartment_id =   var.compartment_ocid

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
  compartment_id =   var.compartment_ocid

  display_name   = "demotfInternetGateway"
  vcn_id         = oci_core_virtual_network.demotfVCN.id
}

# Route Table
resource "oci_core_route_table" "demotfRouteTableViaIGW" {
  compartment_id =   var.compartment_ocid

  vcn_id         = oci_core_virtual_network.demotfVCN.id
  display_name   = "demotfRouteTableViaIGW"
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.demotfInternetGateway.id
  }
}

# Security List
resource "oci_core_security_list" "demotfSecurityList" {
  compartment_id =   var.compartment_ocid

  display_name   = "demotfSecurityList"
  vcn_id         = oci_core_virtual_network.demotfVCN.id

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  dynamic "ingress_security_rules" {
    for_each = var.service_ports
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

# Subnet
resource "oci_core_subnet" "demotfWebSubnet" {
  cidr_block        = var.Subnet-CIDR
  display_name      = "demotfWebSubnet"
  dns_label         = "demotfN1"
  compartment_id    =   var.compartment_ocid

  vcn_id            = oci_core_virtual_network.demotfVCN.id
  route_table_id    = oci_core_route_table.demotfRouteTableViaIGW.id
  dhcp_options_id   = oci_core_dhcp_options.demotfDhcpOptions1.id
  security_list_ids = [oci_core_security_list.demotfSecurityList.id]
}