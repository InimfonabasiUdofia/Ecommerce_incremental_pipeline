select
     updated_at
from {{ source('ecommerce', 'customers') }}
    
