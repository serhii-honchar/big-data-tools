from datetime import datetime, timedelta

import pytz
from airflow import DAG
from airflow.contrib.operators import dataproc_operator
from airflow.contrib.sensors.gcs_sensor import GoogleCloudStorageObjectSensor
from airflow.models import Variable
from airflow.operators.dummy_operator import DummyOperator
from airflow.utils import trigger_rule

bucket = Variable.get('gcs_bucket', 'airflow-task'),

flights_dataset = Variable.get('flights_dataset', 'gs://procamp_hadoop/flight-delays/flights.csv')
airlines_dataset = Variable.get('airlines_dataset', 'gs://procamp_hadoop/flight-delays/airlines.csv')
airports_dataset = Variable.get('airports_dataset', 'gs://procamp_hadoop/flight-delays/airports.csv')

start_date = datetime(2020, 12, 20, 0, 0, 0, tzinfo=pytz.utc)

default_dag_args = {
    'start_date': start_date,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
    'project_id': Variable.get('gcp_project', 'bigdata-procamp-fdb1db6e')
}

spark_args = [flights_dataset, airports_dataset,
              'gs://' + Variable.get('gcs_bucket', 'airflow-task') +
              '/flights/{{execution_date.format("%Y/%m/%d/%H")}}']

# disabled catchup
with DAG(
        dag_id='composer_airflow_task',
        schedule_interval='@hourly',
        default_args=default_dag_args,
        catchup=False) as dag:
    start_task = DummyOperator(task_id="start")

    # according to the task, the sensor definition should be similar to the next one
    # but I've commented it because it was unclear what results it should wait in that folder.
    # I don't remember any task for writing flights data this way.
    # gcs_file_existence_sensor = GoogleCloudStorageObjectSensor(
    #     task_id="gcs_file_existence_sensor",
    #     bucket=Variable.get('gcs_bucket', 'airflow-task'),
    #     object='flights/{{ execution_date.format("%Y/%m/%d/%H") }}' + '/_SUCCESS',
    #     timeout=7200
    # )

    # Create a Cloud Dataproc cluster.
    create_dataproc_cluster = dataproc_operator.DataprocClusterCreateOperator(
        task_id='create_dataproc_cluster',
        cluster_name='composer-airflow-task-cluster-{{ ds_nodash }}',
        num_workers=2,
        zone=Variable.get('gce_zone', 'us-east4-a'),
        master_machine_type='n1-standard-1',
        worker_machine_type='n1-standard-1')

    # define airflow pyspark operator that runs spark dataframes homework
    run_dataproc_spark = dataproc_operator.DataProcPySparkOperator(
        task_id='run_dataproc_spark_task',
        main=Variable.get('pyspark_program', 'gs://airflow-task/spark/lab1-1-with-partitions.py'),
        arguments=spark_args,
        cluster_name='composer-airflow-task-cluster-{{ ds_nodash }}')

    # the sensor that checks whether spark finished his work and wrote to the output path
    gcs_result_sensor = GoogleCloudStorageObjectSensor(
        task_id="gcs_result_sensor",
        bucket=Variable.get('gcs_bucket', 'airflow-task'),
        object='flights/{{ execution_date.format("%Y/%m/%d/%H") }}' + '/_SUCCESS',
        timeout=7200
    )

    delete_dataproc_cluster = dataproc_operator.DataprocClusterDeleteOperator(
        task_id='delete_dataproc_cluster',
        cluster_name='composer-airflow-task-cluster-{{ ds_nodash }}',
        trigger_rule=trigger_rule.TriggerRule.ALL_DONE)

    # Define DAG dependencies.
    start_task >> \
        create_dataproc_cluster >> run_dataproc_spark >> gcs_result_sensor >> delete_dataproc_cluster
