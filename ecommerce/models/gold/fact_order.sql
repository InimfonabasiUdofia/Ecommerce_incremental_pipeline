{{ config(materialized='table') }}




    SELECT
    distinct
        order_surrogate_key,
        product_surrogate_key,
        customer_surrogate_key,
        seller_surrogate_key,
        geolocation_surrogate_key,
        delivered,
        price,
        freight_value,
        price + freight_value AS total_item_value,
        payment_sequential,
        payment_installments,
        payment_value,
        review_score,
        order_purchase_timestamp,
        order_approved_at,
        order_delivered_carrier_date,
        order_delivered_customer_date,
        order_estimated_delivery_date,
        order_purchase_timestamp,
        order_approved_at,
        order_delivered_carrier_date,
        order_delivered_customer_date,
        order_estimated_delivery_date,
      shipping_limit_date 
    FROM {{ ref('obt') }}




