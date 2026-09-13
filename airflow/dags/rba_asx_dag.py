from airflow import DAG
from airflow.providers.standard.operators.bash import BashOperator
from datetime import datetime

# 1. Instantiate the DAG context
with DAG(
    dag_id="rba_asx_daily_dag",
    start_date=datetime(2026, 9, 1),
    schedule='0 9 * * 1-5',
) as dag:
 
 # 2. Define the individual Bash tasks
    task_asx_ingestion = BashOperator(
        task_id="run_asx_ingestion",
        bash_command="python /opt/airflow/project/ingestion/ingest_asx.py"
    )
    
    task_rba_ingestion = BashOperator(
        task_id="run_rba_ingestion",
        bash_command="python /opt/airflow/project/ingestion/ingest_rba.py"
    )
    
    task_load_to_bigquery = BashOperator(
        task_id="load_to_bigquery",
        bash_command="python /opt/airflow/project/ingestion/load_to_bigquery.py"
    )

    task_dbt_run = BashOperator(
        task_id="run_dbt",
        bash_command="cd /opt/airflow/project && dbt run"
    )

    task_dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command="cd /opt/airflow/project && dbt test"
    )
    
# 4. Define task dependencies (the workflow layout) using bitshift operators
    # task_start runs first, then download and process run in parallel, followed by cleanup.
    [task_asx_ingestion, task_rba_ingestion] >> task_load_to_bigquery >> task_dbt_run >> task_dbt_test