{{
    config(
        materialized='incremental',
        unique_key='order_id'
    )
}}

SELECT
    order_id,
    customer_id,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    created_at ,
    updated_at ,
CASE
    WHEN order_status = 'delivered' THEN 1
    ELSE 0
    END AS delivered,
    ROW_NUMBER() OVER (ORDER BY order_id) AS order_surrogate_key,
    CURRENT_TIMESTAMP() AS processed_at

FROM {{ source('ecommerce', 'orders') }}

{% if is_incremental() %}

{% if is_incremental() %}
    where updated_at > (select coalesce(max(updated_at), '1900-01-01') from {{ this }})
{% endif %}

{% endif %}