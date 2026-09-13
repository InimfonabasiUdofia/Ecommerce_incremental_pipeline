{{
    config(
        materialized='incremental',
        unique_key='product_id'
    )
}}

SELECT
    *,
    ROW_NUMBER() OVER (ORDER BY product_id) AS product_surrogate_key,
    CURRENT_TIMESTAMP() AS processed_at

FROM {{ source('ecommerce', 'products') }}

{% if is_incremental() %}
    where updated_at > (select coalesce(max(updated_at), '1900-01-01') from {{ this }})
{% endif %}