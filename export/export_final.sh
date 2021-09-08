# This gcloud command will export the _de-identified_ DICOM instance as a JPEG to the healthcare_export bucket

gcloud healthcare dicom-stores export gcs example-dicom-store \
  --dataset=my-deidentified-dataset \
  --location={GCP_REGION} \
  --gcs-uri-prefix=gs://healthcare_export \
  --mime-type="image/jpeg; transfer-syntax=1.2.840.10008.1.2.4.50"