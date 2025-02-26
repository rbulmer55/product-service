
resource "mongodbatlas_cluster" "cluster" {
  project_id   = var.mongodbatlas_project_id
  name         = "cluster-${var.environment}"
  cluster_type = "REPLICASET"
  replication_specs {
    num_shards = 1
    regions_config {
      region_name     = "EU_WEST_2"
      electable_nodes = 3
      priority        = 7
      read_only_nodes = 0
    }
  }
  #cloud_backup = true
  #auto_scaling_disk_gb_enabled = true

  # Provider Settings "block"
  provider_name               = "AWS"
  provider_instance_size_name = "M10"
}

resource "mongodbatlas_project_ip_access_list" "test" {
  project_id = var.mongodbatlas_project_id
  ip_address = var.application_ip_address
  comment    = "terraform application ip address"
}
