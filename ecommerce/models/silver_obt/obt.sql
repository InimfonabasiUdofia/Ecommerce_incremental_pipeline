{% set configs =[

        {
        "table": "ecommerce.silver.orders",
        "columns":"""        o.order_id,
        o.order_surrogate_key,
                            
                            o.delivered,
                            o.order_purchase_timestamp,
                            o.order_approved_at,
                            o.order_delivered_carrier_date,
                            o.order_delivered_customer_date,
                            o.order_estimated_delivery_date,
                            o.updated_at as order_created_timestamp,
                            o.updated_at as order_updated_timestamp,
                            current_timestamp() AS order_processed_at
                    """,
        "alias": "o"
        
    },
    {
        "table": "ecommerce.silver.customers",
        "columns":"""  c.customer_id,
                        c.customer_surrogate_key,
                        c.customer_unique_id,
                        c.customer_zip_code_prefix,
                        c.customer_city,
                        c.customer_state,
                        c.created_at AS customer_created_timestamp,
                        c.updated_at AS customer_updated_timestamp,
                        current_timestamp() AS customer_processed_at
                    """,
        "alias": "c",
        "join_condition": "o.customer_id = c.customer_id"
    }, 
 
     {
        "table": "ecommerce.silver.o_items",
        "columns":"""        
                             oi.order_item_surrogate_key,
                            oi.order_item_id,
                            oi.shipping_limit_date,
                            oi.price,
                            oi.freight_value,
                            oi.created_at AS order_item_created_timestamp,
                            oi.updated_at AS order_item_updated_timestamp,
                            current_timestamp() AS o_items_processed_at
                    """,
        "alias": "oi",
        "join_condition": "o.order_id = oi.order_id"
    },
     {
        "table": "ecommerce.silver.o_payments",
        "columns":"""       
                         op.order_payment_surrogate_key,
                            op.payment_sequential,
                            op.payment_type,
                            op.payment_installments,
                            op.payment_value,
                            op.created_at AS payment_created_timestamp,
                            op.updated_at AS payment_updated_timestamp,
                            current_timestamp() AS o_payments_processed_at
                    """,
        "alias": "op",
        "join_condition": "o.order_id = op.order_id"
    },
         {
        "table": "ecommerce.silver.o_reviews",
        "columns":"""        r.review_id,
                            r.review_surrogate_key,
                            r.review_score,
                            r.review_comment_title,
                            r.review_comment_message,
                            r.review_creation_date,
                            r.review_answer_timestamp,
                            r.review_creation_date AS review_created_timestamp,
                            r.review_answer_timestamp AS review_updated_timestamp,
                            current_timestamp() AS o_reviews_processed_at
                    """,
        "alias": "r",
        "join_condition": "o.order_id = r.order_id"
    },
     {
        "table": "ecommerce.silver.sellers",
        "columns":"""        s.seller_id,
        s.seller_surrogate_key,
                                s.seller_zip_code_prefix,
                                s.seller_city,
                                s.seller_state,
                                s.created_at AS seller_created_timestamp,
                                s.updated_at AS seller_updated_timestamp,
                                current_timestamp() AS o_sellers_processed_at
                              
                    """,
        "alias": "s",
        "join_condition": "oi.seller_id = s.seller_id"
    },

    {
        "table": "ecommerce.silver.products",
        "columns":"""        p.product_id,
                            p.product_surrogate_key,
                            p.product_category_name,
                            p.product_name_lenght,
                            p.product_description_lenght,
                            p.product_photos_qty,
                            p.product_weight_g,
                            p.product_length_cm,
                            p.product_height_cm,
                            p.product_width_cm,
                            p.created_at AS product_created_timestamp,
                            p.updated_at AS product_updated_timestamp,
                            current_timestamp() AS o_products_processed_at
                    """,
        "alias": "p",
        "join_condition": "oi.product_id = p.product_id"
    },

    {
        "table": "ecommerce.silver.geolocation",
        "columns":"""    g.geolocation_id,
                            g.geolocation_surrogate_key,
                            g.geolocation_zip_code_prefix,
                            g.geolocation_lat,
                            g.geolocation_lng,
                            g.geolocation_city,
                            g.geolocation_state,
                            g.created_at AS geolocation_created_timestamp,
                            g.updated_at AS geolocation_updated_timestamp,
                            current_timestamp() AS o_geolocation_processed_at
                    """,
        "alias": "g",
        "join_condition": "s.seller_zip_code_prefix = g.geolocation_zip_code_prefix"

    }
    
   

] %}

SELECT 
    {% for config in configs %}
        {{ config['columns'] }}{% if not loop.last %},{% endif %}
    {% endfor %}
FROM 
    {% for config in configs %}
        {% if loop.first %}
            {{ config['table'] }} AS {{ config['alias'] }}
        {% else %}
LEFT JOIN
        {{ config['table'] }} AS {{ config['alias'] }} 
        ON {{ config['join_condition'] }}
        {% endif %}
    {% endfor %}
