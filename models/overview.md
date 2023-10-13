{% docs __overview__ %}
# Introduction
This project provides predefined data analytics content for selected SAP financial insights. Includes:
* Billing and pricing
* Order details
* Order fulfillment
* Order status
* Sales performance

Using dbt, it transforms all the necessary SAP tables into the ordertocash table, which is used to create reports in Microsoft Power BI. Dbt is connected to Databricks where all source and target tables are stored.

The current repository contains a dbt project and templates for creating reports in Power BI. Ingesting SAP tables into Databricks isn't part of the project.

# How to start
First you need clone repository
```
git clone https://github.com/DataSentics/sap-order-to-cash.git
```
Then set environment and databricks connection.

## Environment Settings
Create and activate prepared environment.
```
conda env create -f environment.yml -p .venv
conda activate $PWD/.venv
```

Install all required packages.
```
pip install -r requirements.txt
```

Set environment variable DBT_DATABRICKS_TOKEN, that is required to connect databricks.
```
conda env config vars set DBT_DATABRICKS_TOKEN=<your_token>
```

## Databricks Connection
In file `models/schema.yml` set databricks database in which all required SAP tables are prepared.

![schema.yml settings](assets/settings/schema_settings_c.png)

In file `profiles.yml` set your databricks and destination catalog and schema.

![profiles.yml settings](assets/settings/profiles_settings_c.png)

Run project
```
dbt run
```
Now you should have ordertocash table in your Databricks. 

## PowerBI reports
Report templates for Power BI are prepared in folder pbi_templates. 

In Power BI Desktop open selected template. Each template needs just one table (ordertocash), which is the result of running dbt.

First you must provide the Server hostname and HTTP Path for your Databricks SQL Warehouse and location of ordertocash table.

![Databricks connection settings](assets/settings/databricks_connection_f.png)


In next step provide credentials to authenticate with your Databricks SQL Warehouse.

Once all the data is loaded, the report is ready.

![Order details report](assets/reports/order_details.png)

{% enddocs %}
