SELECT encounter_id, 
    TO_CHAR(start_ts, 'YYYYMMDD')::INT  AS encounter_date_key, 
    encounter_type_key,     
    patient_id, 
    provider_id, 
    organization_id,
    base_encounter_cost,
    total_claim_cost,
    payer_coverage AS payer_coverage_amount,
    reason_code,
    reason_description
FROM {{ ref('stg_encounters') }}
LEFT JOIN {{ ref('dim_encounter_type') }} 
USING(encounter_class, encounter_code, encounter_description)