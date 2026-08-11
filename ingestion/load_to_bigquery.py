from google.cloud import bigquery

bucket_name = "nik-rba-asx-data-lake"                                                                    # Initialise BigQuery client
asx_source_uri = f"gs://{bucket_name}/raw/asx/asx_prices.csv"
rba_source_uri = f"gs://{bucket_name}/raw/rba/rba_cash_rate.csv"
asx_table_id = "kestra-sandbox-498004.rba_asx_raw.asx_prices"
rba_table_id = "kestra-sandbox-498004.rba_asx_raw.rba_cash_rate"

client = bigquery.Client()   

asx_job_config = bigquery.LoadJobConfig(                                                          # Configure load job
    source_format=bigquery.SourceFormat.CSV,                                                   # Or NEWLINE_DELIMITED_JSON, PARQUET, etc.                                                                         # Skip header row for CSV
    autodetect=True                                                                           # Automatically detect schema
)

rba_job_config = bigquery.LoadJobConfig(                                                          # Configure load job
    source_format=bigquery.SourceFormat.CSV,                                                   # Or NEWLINE_DELIMITED_JSON, PARQUET, etc.       
    skip_leading_rows = 1,                                                                    # Skip header row for CSV
    autodetect=True                                                                           # Automatically detect schema
)

asx_load_job = client.load_table_from_uri(
    asx_source_uri, asx_table_id, job_config=asx_job_config
)

rba_load_job = client.load_table_from_uri(
    rba_source_uri, rba_table_id, job_config=rba_job_config
)

asx_load_job.result()     
rba_load_job.result()

print(f"Loaded {asx_load_job.output_rows} rows into {asx_table_id}.")
print(f"Loaded {rba_load_job.output_rows} rows into {rba_table_id}.")

