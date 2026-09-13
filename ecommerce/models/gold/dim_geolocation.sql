{{ config(materialized='table') }}

SELECT
    geolocation_surrogate_key,
    geolocation_id,
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state,
   
    current_timestamp() AS dbt_processed_at
FROM {{ ref('obt') }}