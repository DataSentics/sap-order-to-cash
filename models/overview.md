{% docs __overview__ %}
# Introduction
This project provides predefined data analytics content for selected SAP financial insights. Includes:

### Sales Performance

* [Avg Sales Customers & Products](https://app.fabric.microsoft.com/view?r=eyJrIjoiNzBhMTE5NTEtZTlhNi00YTRjLTgyMGUtMjU4OWQwZmVmNTM1IiwidCI6IjU4NTEyN2FhLTg2OTEtNGYyNS05Nzc3LThjYjc4Y2NmMGQ5MSIsImMiOjh9&pageName=ReportSection40434213839b55d73299)
* [Sales Performance 1](https://app.fabric.microsoft.com/view?r=eyJrIjoiNzBhMTE5NTEtZTlhNi00YTRjLTgyMGUtMjU4OWQwZmVmNTM1IiwidCI6IjU4NTEyN2FhLTg2OTEtNGYyNS05Nzc3LThjYjc4Y2NmMGQ5MSIsImMiOjh9&pageName=ReportSection)
* [Sales Performance 2](https://app.fabric.microsoft.com/view?r=eyJrIjoiNzBhMTE5NTEtZTlhNi00YTRjLTgyMGUtMjU4OWQwZmVmNTM1IiwidCI6IjU4NTEyN2FhLTg2OTEtNGYyNS05Nzc3LThjYjc4Y2NmMGQ5MSIsImMiOjh9&pageName=ReportSection5057dc91035ccb3ae0c4)

### Order Fulfillment

* [Fulfillment in Percentages](https://app.fabric.microsoft.com/view?r=eyJrIjoiYjk2MjIwZWEtZjVhNy00YThhLWJiZjgtNzQ1OTM1NDBlOTcxIiwidCI6IjU4NTEyN2FhLTg2OTEtNGYyNS05Nzc3LThjYjc4Y2NmMGQ5MSIsImMiOjh9&pageName=ReportSection)
* [Order to Delivery Cycle Time](https://app.fabric.microsoft.com/view?r=eyJrIjoiYjk2MjIwZWEtZjVhNy00YThhLWJiZjgtNzQ1OTM1NDBlOTcxIiwidCI6IjU4NTEyN2FhLTg2OTEtNGYyNS05Nzc3LThjYjc4Y2NmMGQ5MSIsImMiOjh9&pageName=ReportSection967ba4b26a08b0552ab8)

### Billing and Pricing

* [Price Adjustments based on Customer](https://app.fabric.microsoft.com/view?r=eyJrIjoiNGYzOWI2OTktNzU0Mi00Zjk4LThkOWYtZmEyNTJiN2RlZmY3IiwidCI6IjU4NTEyN2FhLTg2OTEtNGYyNS05Nzc3LThjYjc4Y2NmMGQ5MSIsImMiOjh9&pageName=ReportSection)
* [Price Adjustments based on Product](https://app.fabric.microsoft.com/view?r=eyJrIjoiNGYzOWI2OTktNzU0Mi00Zjk4LThkOWYtZmEyNTJiN2RlZmY3IiwidCI6IjU4NTEyN2FhLTg2OTEtNGYyNS05Nzc3LThjYjc4Y2NmMGQ5MSIsImMiOjh9&pageName=ReportSectionaae184c0cc105036697c)

### Order Information

* [Order Status](https://app.powerbi.com/view?r=eyJrIjoiOTkzNDc1ODgtNGYxZC00MjFhLWI3MTItMTQwOTUwZThmYTAxIiwidCI6IjU4NTEyN2FhLTg2OTEtNGYyNS05Nzc3LThjYjc4Y2NmMGQ5MSIsImMiOjh9)
* [Order Details](https://app.powerbi.com/view?r=eyJrIjoiZjBkMTFjYjYtZmE2Ni00ZDA1LWJiZWEtMmE1NmRhZmMxY2QzIiwidCI6IjU4NTEyN2FhLTg2OTEtNGYyNS05Nzc3LThjYjc4Y2NmMGQ5MSIsImMiOjh9)

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
