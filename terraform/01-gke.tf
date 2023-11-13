resource "google_container_cluster" "primary" {
  name     = var.gke-name
  location = "us-central1"

  remove_default_node_pool = true
  initial_node_count       = 1
  
  network = google_compute_network.vpc_network.id
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "node-pool"
  location   = "us-central1"
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"
  }
}