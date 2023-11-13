terraform {
  backend "gcs" {
    bucket  = "tf-state-nuv"
    prefix  = "terraform/state"
  }
}