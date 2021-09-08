provider "google" {
    project = var.project
    region = var.region
}

module "function" {
    source = "./modules/function"
    project = var.project
}

module "healthcare" {
    source = "./modules/healthcare"
    region = var.region
}