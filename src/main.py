import base64
from parse import *
import requests

def dicomProcesser(event, context):
    """Triggered from a message on a Cloud Pub/Sub topic.
    Args:
         event (dict): Event payload.
         context (google.cloud.functions.Context): Metadata for the event.
    """

    # Extract the relevant portions from the Pub/Sub message.
    pubsub_message = base64.b64decode(event['data']).decode('utf-8')
    extract = parse("projects/{project}/locations/{location}/datasets/{datasetName}/dicomStores/{storeName}/dicomWeb/studies/{studyId}/series/{seriesId}/instances/{instanceId}", pubsub_message)
    dicom_dict = extract.named

    project_id = dicom_dict["project"]
    location = dicom_dict["location"]
    dataset_name = dicom_dict["datasetName"]
    destination_dataset_id = 'my-deidentified-dataset'

    source_dataset = "projects/{}/locations/{}/datasets/{}".format(
        project_id, location, dataset_name
    )
    destination_dataset = "projects/{}/locations/{}/datasets/{}".format(
        project_id, location, destination_dataset_id
    )

    from googleapiclient import discovery

    api_version = "v1"
    service_name = "healthcare"
    # Returns an authorized API client by discovering the Healthcare API
    # and using GOOGLE_APPLICATION_CREDENTIALS environment variable.
    client = discovery.build(service_name, api_version)

    body = {
          "destinationDataset" : destination_dataset,
          "config" : {
               "dicom": {
                         "filterProfile": "ATTRIBUTE_CONFIDENTIALITY_BASIC_PROFILE"
                    },
                    "image": {
                         "textRedactionMode": "REDACT_ALL_TEXT"
                    }
          }
     }

    request = (
        client.projects()
        .locations()
        .datasets()
        .deidentify(sourceDataset=source_dataset, body=body)
    )

    response = request.execute()
    print(
        "Data in dataset {} de-identified."
        "De-identified data written to {}".format(dataset_name, destination_dataset_id)
    )
    return response

 
