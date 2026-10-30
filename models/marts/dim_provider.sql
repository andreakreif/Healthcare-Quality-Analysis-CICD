SELECT 
    provider_id,
    provider_name,
    provider_gender,
    provider_specialty,
    provider_latitude,
    provider_longitude, 
    organization_id
    FROM {{ ref('stg_providers') }};
