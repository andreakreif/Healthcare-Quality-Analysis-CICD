with source as (
	select *
	from {{ ref( 'encounters') }}
),              
renamed as (
	select
		Id as encounter_id,
		Start as start_ts,
		Stop as stop_ts,
		Patient as patient_id,
		Organization as organization_id,
		Provider as provider_id,
		Payer as payer_id,
		EncounterClass as encounter_class,
		Code as encounter_code,
		Description as encounter_description,
		Base_Encounter_Cost as base_encounter_cost,
		Total_Claim_Cost as total_claim_cost,
		Payer_Coverage as payer_coverage,
		ReasonCode as reason_code,      
		ReasonDescription as reason_description
	from source
)
select *
from renamed
