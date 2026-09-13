{{
    config(
        materialized='incremental',
        unique_key='review_id'
    )
}}

SELECT
    ROW_NUMBER() OVER (ORDER BY review_id) AS review_surrogate_key,
    review_id,
    order_id,
    COALESCE(review_score, 0) AS review_score,
    COALESCE(review_comment_title, 'No comment') AS review_comment_title,
    COALESCE(review_comment_message, 'No comment') AS review_comment_message,
    review_creation_date,
    review_answer_timestamp,
    CURRENT_TIMESTAMP() AS processed_at

FROM {{ source('ecommerce', 'order_reviews') }}

{% if is_incremental() %}
    where review_creation_date > (select coalesce(max(review_answer_timestamp), '1900-01-01') from {{ this }})
{% endif %}