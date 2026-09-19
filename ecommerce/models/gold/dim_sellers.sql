{{ config(
    materialized='table'
) }}

SELECT
distinct
    seller_surrogate_key,
    seller_zip_code_prefix,
    seller_city,
    seller_state,
    seller_created_timestamp,
seller_updated_timestamp,
    current_timestamp() AS dbt_processed_at

FROM {{ ref('sellers') }}