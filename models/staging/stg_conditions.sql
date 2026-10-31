with source as (
	select *
	from {{ ref('conditions') }}
),
renamed as (
	select 
        {{dbt_utils.generate_surrogate_key(['encounter','patient','code'])}} as condition_id,
        start as start_dt,
        stop as stop_dt,
        patient as patient_id,
        encounter as encounter_id,
        code as condition_code,
        description as condition_description
	from source
)

select *
from renamed
