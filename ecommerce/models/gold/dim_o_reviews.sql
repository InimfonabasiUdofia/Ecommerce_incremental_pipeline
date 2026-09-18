{{ config(
    materialized='table'
) }}

SELECT
    review_surrogate_key,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp,
      review_created_timestamp,
    review_updated_timestamp,
    current_timestamp() AS dbt_processed_at

FROM {{ ref('obt') }}

where review_surrogate_key IS NOT NULL