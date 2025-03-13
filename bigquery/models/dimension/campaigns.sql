

with audience_master as (

    select * 
    from {{ref('audience_master')}}

)

select distinct
    campaign_code, 
    campaign_start_date, 
    campaign_end_date
from audience_master