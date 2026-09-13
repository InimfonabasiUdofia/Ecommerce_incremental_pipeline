{{ config( materialized='table' ) }} 
SELECT
distinct
 product_surrogate_key,
   product_category_name,
    product_name_lenght,
     product_description_lenght,
      product_photos_qty,
    product_weight_g, 
    product_length_cm, 
    product_height_cm, 
    product_width_cm, 
 current_timestamp() AS dbt_processed_at FROM {{ ref('obt') }}
WHERE product_surrogate_key IS NOT NULL