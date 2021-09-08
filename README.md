# Google Cloud - Healthcare Data Engine
This repository serves as an example on how to use Google's Healthcare Data Engine to run de-identification procedures on DICOM instances. 

## Objective
The system will de-identify DICOM instances that are uploaded to a DICOM datastore in the Healthcare Data Engine.

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
2. Create a Terraform service account and place the service account key in a JSON format within the `terraform/` directory.

**Usage**
Within the `terraform/` directory:

1. `terraform plan` to plan out resource creations.
2. `terraform apply` to create resources.
3. Use `upload.sh` to upload DICOM instances to the Healthcare engine.
4. `terraform destroy` to destroy resources once you're finished with this example.