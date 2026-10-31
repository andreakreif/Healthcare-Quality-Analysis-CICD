/* 
  NOTE:  The source data was de-duped in Excel to get the uniqueness to work.
      This is reasonable since in a real world scenario, this would be handled outside
      the scope of dbt.
*/
with source as (
	select *
	from {{ ref('observations') }}
    where code not in ('QALY', 'DALY','QOLS')
),

renamed as (    
	select 
        {{dbt_utils.generate_surrogate_key(['date','patient','encounter','code','value'])}} as observation_id,
        date as observation_date,
        patient as patient_id,
        encounter as encounter_id,
        code as observation_code,
        description as observation_description,
        value as observation_value,
        units as observation_units,
        type as observation_type

	from source
)

select *
from renamed
