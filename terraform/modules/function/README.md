# Cloud Function Module

This module creates a Cloud Function to run the de-identification processes on the uploaded DICOM instances.

The function's source code is found within the `src/` directory. Once the terraform code is run, it handles the following: a zip file of the function code, a storage bucket, and uploading the function's artifacts to Cloud Storage. 

Changing the function's code and running terraform again will recreate the function with your changes.

Additionally, terraform will create a service account with the necessary permissions to invoke the function and the Healthcare API methods needed to de-identify materials.

**All terraform commands should be run from `terraform/`.**