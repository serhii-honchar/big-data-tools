## Apache Airflow

Prerequisites:
1. Composer cluster is up and running
2. Flights dataset consisting of 3 files is uploaded to GCS

Steps to run Airflow:
1. Find airflow-variables.json file in current directory and edit it according to required configuration.
2. Import it to Airflow in Admin->Variables.
3. Upload hw/hw8-airflow/lab1-1-with-partitions.py to GCP 
4. Upload airflow/airflow-lab/airflow-lab.py file to dag directory
5. Find results in specified directory in GCS