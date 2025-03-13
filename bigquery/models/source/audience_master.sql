
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

with source_data as (

    select * 
    from `gcp-wow-rwds-ai-mmm-dev.DEV_MMM.MMM_AUDIENCE_MASTER`

)

select *
from source_data
limit 10000
