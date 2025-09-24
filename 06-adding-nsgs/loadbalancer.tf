
# Public Load Balancer
resource "oci_load_balancer" "demotfPublicLoadBalancer" {
  shape = var.lb_shape

  dynamic "shape_details" {
    for_each = local.is_flexible_lb_shape ? [1] : []
    content {
      minimum_bandwidth_in_mbps = var.flex_lb_min_shape
      maximum_bandwidth_in_mbps = var.flex_lb_max_shape
    }
  }

  compartment_id = oci_identity_compartment.DemoTF-Compartment.id
  subnet_ids = [
    oci_core_subnet.demotfLBSubnet.id
  ]
  display_name = "demotfPublicLoadBalancer"
  network_security_group_ids = [oci_core_network_security_group.demotfWebSecurityGroup.id]
}

# LoadBalancer Listener
resource "oci_load_balancer_listener" "demotfPublicLoadBalancerListener" {
  load_balancer_id         = oci_load_balancer.demotfPublicLoadBalancer.id
  name                     = "demotfPublicLoadBalancerListener"
  default_backend_set_name = oci_load_balancer_backendset.demotfPublicLoadBalancerBackendset.name
  port                     = 80
  protocol                 = "HTTP"
}

# LoadBalancer Backendset
resource "oci_load_balancer_backendset" "demotfPublicLoadBalancerBackendset" {
  name             = "demotfPublicLBBackendset"
  load_balancer_id = oci_load_balancer.demotfPublicLoadBalancer.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = "80"
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
  }
}

# LoadBalanacer Backend for WebServer1 Instance
resource "oci_load_balancer_backend" "demotfPublicLoadBalancerBackend1" {
  load_balancer_id = oci_load_balancer.demotfPublicLoadBalancer.id
  backendset_name  = oci_load_balancer_backendset.demotfPublicLoadBalancerBackendset.name
  ip_address       = oci_core_instance.demotfWebserver1.private_ip
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

# LoadBalanacer Backend for WebServer2 Instance
resource "oci_load_balancer_backend" "demotfPublicLoadBalancerBackend2" {
  load_balancer_id = oci_load_balancer.demotfPublicLoadBalancer.id
  backendset_name  = oci_load_balancer_backendset.demotfPublicLoadBalancerBackendset.name
  ip_address       = oci_core_instance.demotfWebserver2.private_ip
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

