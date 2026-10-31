with source as (
	select *
	from {{ ref('organizations') }}
),

renamed as (
	select id as organization_id,
        name as organization_name,
        address as organization_address,
        city as organization_city,
        state as organization_state,
        zip as organization_zip,
        lat as organization_latitude,
        lon as organization_longitude
	from source
)

select *
from renamed
