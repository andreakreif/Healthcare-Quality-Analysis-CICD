with source as (
	select *
	from {{ ref( 'providers') }}
),
renamed as (
    select
        id as provider_id,
        organization as organization_id,
        name as provider_name,
        gender as provider_gender,
        speciality as provider_specialty,        
        address as provider_address,
        city as provider_city,
        state as provider_state,
        zip as provider_zip,
        lat as provider_latitude,
        lon as provider_longitude
    from source
)

select *
from renamed
