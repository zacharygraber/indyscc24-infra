# Create a subnet for the team
resource "openstack_networking_subnet_v2" "hpl_subnet" {
  network_id = var.auto_allocated_network_id
  subnetpool_id = var.subnet_pool_id
  name       = var.team_name
}

# Create an interface on the router for the subnet
resource "openstack_networking_router_interface_v2" "indyscc_subnet_interface" {
  router_id = var.router_id
  subnet_id = openstack_networking_subnet_v2.hpl_subnet.id
}