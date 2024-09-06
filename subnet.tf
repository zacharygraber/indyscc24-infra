# Create a subnet for each team
resource "openstack_networking_subnet_v2" "indyscc_subnet" {
  network_id = var.auto_allocated_network_id
  cidr       = "192.168.0.0/24"
  name       = "indyscc-subnet-${var.team_name}"
}