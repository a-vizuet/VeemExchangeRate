terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.40.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

provider "google" {
  // * MUST HAVE AN EDITOR SERVICE ACCOUNT
  credentials = file("terraform-service-account.json")
  project     = var.project-id
  region      = var.project-region
  zone        = var.project-zone
}
