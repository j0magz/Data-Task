import os
import requests
import pandas as pd
from sqlalchemy import create_engine
from io import StringIO

# Fetch database connection details from environment variables
db_user = os.getenv('DB_USER')
db_password = os.getenv('DB_PASSWORD')
db_host = os.getenv('DB_HOST')
db_port = os.getenv('DB_PORT')
db_name = 'covid19'

# GitHub raw URLs for the CSV files
urls = {
    "confirmed": "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv",
    "deaths": "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv",
    "recovered": "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv"
}

# Function to fetch and load data into pandas DataFrame
def fetch_data(url):
    response = requests.get(url)
    if response.status_code == 200:
        csv_data = StringIO(response.text)
        return pd.read_csv(csv_data)
    else:
        print(f"Failed to fetch data: {response.status_code}")
        return None

# Fetch all datasets
dataframes = {}
for key, url in urls.items():
    df = fetch_data(url)
    if df is not None:
        dataframes[key] = df

# Processing example: Drop rows with any missing values
for key, df in dataframes.items():
    df.dropna(inplace=True)
    dataframes[key] = df

# Create a SQLAlchemy engine for PostgreSQL
engine = create_engine(f'postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}')

# Insert each DataFrame into the PostgreSQL database
for key, df in dataframes.items():
    table_name = f'covid19_{key}'  # Table names: covid19_confirmed, covid19_deaths, covid19_recovered
    df.to_sql(table_name, engine, if_exists='replace', index=False)
    print(f"Data for {key} inserted into table {table_name}.")
