SELECT 
    patient_id,
    patient_birthdate,
    patient_deathdate,
    patient_race,           
    patient_ethnicity,
    patient_gender
    patient_state,
    patient_county,
    patient_zip,
    patient_latitude,
    patient_longitude
FROM {{ ref('stg_patients') }}