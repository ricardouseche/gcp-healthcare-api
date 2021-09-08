# Google Cloud - Healthcare Data Engine
This repository serves as an example on how to use Google's Healthcare Data Engine to run de-identification procedures on DICOM instances. 

## Objective
The system will de-identify DICOM instances that are uploaded to a DICOM datastore in the Healthcare Data Engine. This process will remove all burnt-in text on the X-ray images. Refer to the [documentation](https://cloud.google.com/healthcare/docs/how-tos/dicom-deidentify) for other de-identification options.

The process is as follows:
1. A DICOM instance is uploaded to the datastore.
2. The Healthcare Data Engine sends a notification to Pub/Sub about this change.
3. Our Cloud Function is triggered by the previous notification.
4. The de-identification process is kicked off by the function.
5. Finally, we are provided with a separate, de-identified dataset (copied from the original).

Architecture:

![Architecture](img/Healthcare%20API.png)

## Terraform Resources
Terraform is used to create a several resources:

1. A healthcare dataset.
2. A DICOM instance store together with a Pub/Sub Topic that sends change notifications.
3. A Cloud Function that is triggered by the above Pub/Sub messages, plus the function artifacts and storage buckets for it.
4. The necessary service accounts with roles to be able to invoke the Cloud Function and Healthcare API methods for the DICOM instances.

## DICOM Instances
DICOM instances are available online for free. The samples contained here are from dicomlibrary.com. The Healthcare Data Engine provides with API methods to work with HL7v2, FHIR, and DICOM. This repository is focused around the DICOM format, but can be extended to work with other types of healthcare data and other GCP resources. For example, FHIR and BigQuery.


# Instructions

**Prerequisites**

1. Make sure you have replaced `{PROJECT_ID}`, `{GCP_REGION}` with the relevant details for your case.
2. Make sure you have `gcloud` installed to be able to authenticate with GCP.

**Usage**

Start within the `terraform/` directory:

1. `terraform plan` to plan out resource creations.
2. `terraform apply` to create resources.
3. `terraform destroy` to destroy resources once you're finished with this example. 

**Note: The only resource that will not be deleted will be the de-identified dataset as that one was created via API. Make sure to manually delete it at the end.**

This will create all of the needed resources to process DICOM images.

Within `dicoms/`:

1. Replace the project ID and GCP region to work with in the `upload.sh` script. 
2. Run `upload.sh`.

Within `export/`:

1. Replace the GCP region in `export_original.sh` and `export_final.sh`.
2. Use `export_original.sh` to get a JPEG export of the originally uploaded DICOM file.
3. Use `export_final.sh` to get a JPEG export of the de-identified DICOM file.


# Viewing results of the de-identification process

Working with DICOM instances can be a bit difficult without setting up a DICOM viewer. This repo **does not** deploy a DICOM viewer. However, you can export DICOM instances contained within the Healthcare Data Engine to a Cloud Storage bucket to compare the original vs the processed image.

Samples of the before and after are available within the `img/` directory.

Before:
![Before de-id](img/Before%20de-id.jpg)

After:
![After de-id](img/After%20de-id.jpg)