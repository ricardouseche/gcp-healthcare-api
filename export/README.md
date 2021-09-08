# Viewing original and resulting DICOM images

The code used in this repo will upload and process DICOM instances. These files can be viewed using a special DICOM viewer, however we do not go into setup and usage of a DICOM viewer. Instead, the Healthcare API provides with the functionality of exporting DICOM instances into JPEG or PNG files.

The script `export_original.sh` exports the original DICOM instance as JPEG, and `export_final.sh` exports the de-identified DICOM instance as JPEG. Both can be found in the `healthcare_export` bucket.