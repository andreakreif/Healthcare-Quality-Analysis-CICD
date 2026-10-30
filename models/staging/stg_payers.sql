with source as (
	select *
	from {{ source('synthea', 'payers') }}
),
renamed as (
    select
        id as payer_id,
        name as payer_name,
    from source
)
select *
from renamed
