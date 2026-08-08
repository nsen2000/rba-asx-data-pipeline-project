import yfinance as yf
import pandas as pd
from datetime import date
from google.cloud import storage

tickers = ["^AXJO", "CBA.AX", "BHP.AX", "WES.AX", "CSL.AX"]                    # Array holder all tickers in ASX data
ticker_holder = []                                                             # Empty array to hold multiple dataframed in for loop
bucket_name = "nik-rba-asx-data-lake"                                          # Bucket for data to be uploaded into

for ticker in tickers:
    df = yf.download(ticker, start="2024-01-01", end=date.today(), progress=False, auto_adjust=True)
    df.columns = df.columns.get_level_values(0)                                # Flatten: keep price type, drop ticker-name level
    df["ticker"] = ticker                                                      # Creating new column and filling in the ticker
    ticker_holder.append(df)                                                   # Appending data into ticket holder variable

combined = pd.concat(ticker_holder)                                            # Converting 
asx_raw = combined.to_csv()

client = storage.Client()                                                      # Creating client to connect to GCS
bucket = client.bucket(bucket_name)                                            # Pointing to bucket created within GCS
blob = bucket.blob("raw/asx/asx_prices.csv")                                   # Specific path within the bucket
blob.upload_from_string(asx_raw)                                               # Uploading the data into the blob
print(f"Uploaded ASX data to gs://{bucket_name}/raw/asx/asx_prices.csv")


