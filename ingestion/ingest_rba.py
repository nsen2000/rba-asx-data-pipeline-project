import requests
from google.cloud import storage

url = "https://www.rba.gov.au/statistics/tables/csv/f1.1-data.csv"             # Link to where the data sits
r = requests.get(url, timeout=30, headers={"User-Agent": "Mozilla/5.0"})       # Retrieving data from source and storing in variable
bucket_name = "nik-rba-asx-data-lake"                                          # Name of the bucket created using Terraform
r.raise_for_status()

client = storage.Client()                                                      # Creating client to connect to GCS
bucket = client.bucket(bucket_name)                                            # Pointing to bucket created within GCS
blob = bucket.blob("raw/rba/rba_cash_rate.csv")                                # Specific path within the bucket
blob.upload_from_string(r.text)                                                # Uploading the data into the blob
print(f"Uploaded RBA data to gs://{bucket_name}/raw/rba/rba_cash_rate.csv")

