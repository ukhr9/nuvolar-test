provider "google" {
    credentials = file("sa.json")

    project     = "playground-s-11-1944ec9e"
    region      = "us-central1"
    zone        = "us-central1-a"
}