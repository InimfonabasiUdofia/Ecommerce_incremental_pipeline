
from datetime import datetime

from airflow.sdk import dag, task
from airflow.operators.bash import BashOperator


DBT_PROJECT_DIR = "/usr/local/ecommerce"


@dag(
    dag_id="orchestrate",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False,
)
def orchestrate():

    @task
    def ingest_cdc():
        return "CDC data ingested"

    @task.bash
    def clean_target():
        return (
            f"rm -rf {DBT_PROJECT_DIR}/target "
            f"&& rm -rf /usr/local/ecormmerce/ecommerce/logs"
        )

    @task.bash
    def source_freshness():
        return (
            f"cd {DBT_PROJECT_DIR} "
            f"&& dbt deps "
            f"&& dbt source freshness"
        )

    silver_technical = BashOperator(
        task_id="silver_technical",
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt run --select silver",
    )

    silver_obt_technical = BashOperator(
        task_id="silver_obt_technical",
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt run --select silver_t",
    )

    gold_technical = BashOperator(
        task_id="gold_technical",
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt run --select gold",
    )

    # Task dependencies
    (
        ingest_cdc()
        >> clean_target()
        >> source_freshness()
        >> silver_technical
        >> silver_obt_technical
        >> gold_technical
    )


orchestrate()
