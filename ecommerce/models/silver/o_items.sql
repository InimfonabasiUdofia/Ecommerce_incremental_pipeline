{{
    config(
        materialized='incremental',
        unique_key='order_id'
    )
}}

SELECT
  ROW_NUMBER() OVER (ORDER BY order_id) AS order_item_surrogate_key,
    *,
    CURRENT_TIMESTAMP() AS processed_at

FROM {{ source('ecommerce', 'order_items') }}

{% if is_incremental() %}
    where updated_at > (select coalesce(max(updated_at), '1900-01-01') from {{ this }})
{% endif %}