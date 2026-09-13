{{
    config(
        materialized='incremental',
        unique_key='geolocation_id'
    )
}}

SELECT
    *,
    ROW_NUMBER() OVER (ORDER BY geolocation_id) AS geolocation_surrogate_key,
    CURRENT_TIMESTAMP() AS processed_at

FROM {{ source('ecommerce', 'geolocation') }}

{% if is_incremental() %}
    where updated_at > (select coalesce(max(updated_at), '1900-01-01') from {{ this }})
{% endif %}