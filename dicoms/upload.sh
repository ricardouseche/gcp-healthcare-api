# Replace {PROJECT_ID} and {GCP_REGION} with your project ID and desired region.

curl -X POST \
    -H "Content-Type: application/dicom" \
    -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
    https://healthcare.googleapis.com/v1/projects/{PROJECT_ID}/locations/{GCP_REGION}/datasets/example-dataset/dicomStores/example-dicom-store/dicomWeb/studies \
    --data-binary @original.dcm