{{ config(materialized='table') }}

SELECT
distinct
    geolocation_surrogate_key,
    geolocation_id,
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state,
    geolocation_created_timestamp,
    geolocation_updated_timestamp,
   
    current_timestamp() AS dbt_processed_at
FROM {{ ref('obt') }}