# COVID-19 Data Pipeline

## Overview

This project is designed to automate the ingestion, transformation, and testing of COVID-19 data from the Johns Hopkins University repository. The data includes global confirmed cases, deaths, and recovered cases. The project utilizes dbt for data transformation and SQLAlchemy for database operations. The data is stored in a PostgreSQL database for further analysis and reporting.

## Project Structure
```
/<your-repo-name>
│
├── .github/
│   └── workflows/
│       └── covid19_data_pipeline.yml  # GitHub Actions workflow file
│
├── data_ingestion/
│   ├── __init__.py                    # Optional, indicates this is a package
│   ├── ingest_covid_data.py           # Main Python script for data ingestion
│
├── dbt/
│   ├── models/
│   │   ├── staging/                   # Staging layer
│   │   │   ├── staging_covid19_confirmed.sql
│   │   │   ├── staging_covid19_deaths.sql
│   │   │   └── staging_covid19_recovered.sql
│   │   ├── transformed/               # Transformed data models
│   │   │   ├── covid19_confirmed.sql
│   │   │   ├── covid19_deaths.sql
│   │   │   ├── covid19_recovered.sql
│   │   ├── analysis/                  # Analysis models
│   │   │   ├── top_countries_confirmed.sql
│   │   │   ├── daily_new_cases.sql
│   │   │   └── confirmed_deaths_correlation.sql
│   │   ├── tests/                     # Custom tests
│   │   │   ├── uniqueness_tests.yml
│   │   │   ├── not_null_tests.yml
│   │   │   ├── test_confirmed_cases.sql
│   │   │   ├── test_deaths_cases.sql
│   │   │   └── test_recovered_cases.sql
│   │   └── source/
│   │       └── sources.yml            # Source definitions
│   ├── dbt_project.yml                # dbt project configuration
│   └── profiles.yml                   # dbt profiles configuration
│
├── requirements.txt                   # Python dependencies
├── README.md                          # Project documentation
└── .gitignore                         # Git ignore file
```

## Setup Instructions

### Prerequisites

- **Python 3.9+**
- **PostgreSQL** (local or remote instance)
- **GitHub Account** (for running GitHub Actions)

### Installation

1. **Clone the Repository**

   ```sh
   git clone https://github.com/j0magz/Data-Task.git
   cd Data-Task

2. **Create a Virtual Environment and Activate It**
    ```sh
    python -m venv venv
    source venv/bin/activate  # On Windows use `venv\Scripts\activate`
3. **Install Python Dependencies**
    ```sh
    pip install -r requirements.txt

### Running the Pipeline

1. **Data Ingestion**

    ```sh
    python data_ingestion/ingest_covid_data.py

2. **Data Transformation**

    ```sh
    dbt run --project-dir dbt

3. **Testing**

    ```sh
    dbt test --project-dir dbt

### Automation with GitHub Actions
The GitHub Actions workflow defined in .github/workflows/covid19_data_pipeline.yml automates the entire process. The workflow is triggered on push to the main branch or can be manually triggered. It includes steps for setting up the environment, running the ingestion script, and executing dbt commands.

### Data Quality and Testing
The project includes various tests to ensure data quality:

- Generic Tests : Check for unique and not-null constraints on important columns.
- Custom Tests: Ensure data integrity, such as no negative values in case counts.


All tests are defined in the dbt/models/tests/ directory and are executed using dbt.

