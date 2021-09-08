provider "google" {
    credentials = file("tf-key.json")
    project = var.project
    region = var.region
}

module "function" {
    source = "./modules/function"
    project = var.project
}

module "healthcare" {
    source = "./modules/healthcare"
}