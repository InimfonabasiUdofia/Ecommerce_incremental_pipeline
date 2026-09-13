{{ config(
    materialized='table'
) }}

SELECT
    seller_surrogate_key,
    seller_zip_code_prefix,
    seller_city,
    seller_state,
    current_timestamp() AS dbt_processed_at

FROM {{ ref('sellers') }}