variable "project" {}

# Create a storage bucket
resource "google_storage_bucket" "function_bucket" {
    name = "dicom-function"
}

# Zip up the function's code for uploading
data "archive_file" "function_src" {
    type = "zip"
    source_dir  = "${path.root}/../src" # Directory where your Python source code is
    output_path = "${path.root}/../generated/src.zip"
}

# Upload the zipped files to the bucket
resource "google_storage_bucket_object" "zipped_func" {
    name   = "${data.archive_file.function_src.output_md5}.zip"
    bucket = google_storage_bucket.function_bucket.name
    source = "${path.root}/../generated/src.zip"
}

# Create the cloud function and specify the bucket and function objects within that bucket
resource "google_cloudfunctions_function" "dicomProcesser" {
    name = "dicomProcesser"
    description = "De-identification function for DICOM instances."
    available_memory_mb = 256
    source_archive_bucket = google_storage_bucket.function_bucket.name
    source_archive_object = google_storage_bucket_object.zipped_func.name
    timeout = 60
    runtime = "python38"
    service_account_email = "${google_service_account.healthcare-sa.email}"
    entry_point = "dicomProcesser"
    event_trigger {
      event_type = "providers/cloud.pubsub/eventTypes/topic.publish"
      resource = "dicom-notifications"
    }
}

# We'll also create a new service account, and add the needed roles for calling the Clound Function and the Healthcare API
resource "google_service_account" "healthcare-sa" {
  account_id = "healthcare-sa"
  display_name = "Healthcare Service Account"
}

resource "google_project_iam_member" "datasetAdmin" {
  project = var.project
  role    = "roles/healthcare.datasetAdmin"
  member  = "serviceAccount:${google_service_account.healthcare-sa.email}"
}

resource "google_project_iam_member" "dicomStoreAdmin" {
  project = var.project
  role    = "roles/healthcare.dicomStoreAdmin"
  member  = "serviceAccount:${google_service_account.healthcare-sa.email}"
}

resource "google_project_iam_member" "dicomEditor" {
  project = var.project
  role    = "roles/healthcare.dicomEditor"
  member  = "serviceAccount:${google_service_account.healthcare-sa.email}"
}