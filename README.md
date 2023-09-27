# sap-order-to-cash

## Environment setup
1. `conda env create -f environment.yml -p .venv`
1. `conda activate $PWD/.venv`
1. `pip install -r requirements.txt`
1. `conda env config vars set DBT_DATABRICKS_TOKEN=<your_token>`

## Project databricks settings
1. in models/schema.yml is databricks source settings
1. in profiles.yml is databricks destination settings
