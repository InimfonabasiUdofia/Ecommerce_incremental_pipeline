{{ config( materialized='table' ) }} 
SELECT 
    distinct
customer_surrogate_key,
customer_zip_code_prefix,
customer_city,
customer_state,
customer_created_timestamp,
customer_updated_timestamp,
 current_timestamp() AS dbt_processed_at
FROM {{ ref('obt') }}