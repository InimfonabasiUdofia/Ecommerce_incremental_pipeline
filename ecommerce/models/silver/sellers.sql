{{
    config(
        materialized='incremental',
        unique_key='seller_id'
    )
}}

SELECT
    ROW_NUMBER() OVER (ORDER BY seller_id) AS seller_surrogate_key,
    seller_id,
    seller_zip_code_prefix,
    upper(seller_state) AS seller_state,
    lower(seller_city) AS seller_city,  
    updated_at,
    created_at,
    CURRENT_TIMESTAMP() AS processed_at

FROM {{ source('ecommerce', 'sellers') }}


{% if is_incremental() %}
    where updated_at > (select coalesce(max(updated_at), '1900-01-01') from {{ this }})
{% endif %}