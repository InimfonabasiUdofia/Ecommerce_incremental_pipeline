{{
    config(
        materialized='incremental',
        unique_key='customer_id'
    )
}}

SELECT

    ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_surrogate_key,
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    upper(customer_state) AS customer_state,
    lower(customer_city) AS customer_city,  
    updated_at,
    created_at,
    CURRENT_TIMESTAMP() AS processed_at

FROM {{ source('ecommerce', 'customers') }}

{% if is_incremental() %}
    where updated_at > (select coalesce(max(updated_at), '1900-01-01') from {{ this }})
{% endif %}