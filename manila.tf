resource "openstack_sharedfilesystem_share_v2" "scratch_share" {
    name = "${var.team_name}-scratch"
    description = "Scratch space share for IndySCC team ${var.team_name}"
    share_proto = "CEPHFS"
    size = 1000
    share_type = "cephfsnativetype"
}

resource "openstack_sharedfilesystem_share_access_v2" "share_access" {
  share_id     = openstack_sharedfilesystem_share_v2.scratch_share.id
  access_type  = "cephx"
  access_to    = "indyscc-${var.team_name}-rw"
  access_level = "rw"
}