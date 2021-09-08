resource "google_healthcare_dataset" "default" {
  name      = "example-dataset"
  location  = "{GCP_REGION}"
  time_zone = "America/Chicago"
}

resource "google_healthcare_dicom_store" "default" {
    name = "example-dicom-store"
    dataset = google_healthcare_dataset.default.id

    notification_config {
        pubsub_topic = google_pubsub_topic.topic.id
    }
}

resource "google_pubsub_topic" "topic" {
  name     = "dicom-notifications"
}

resource "google_storage_bucket" "healthcare_export" {
  name = "healthcare_export"
}