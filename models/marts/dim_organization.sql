SELECT
    organization_id,
    organization_name,
    organization_city,
    organization_state,
    organization_zip
FROM {{ ref('stg_organizations') }}