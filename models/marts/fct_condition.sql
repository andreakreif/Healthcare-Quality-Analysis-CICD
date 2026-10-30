SELECT patient_id,
    encounter_id,
    code_key AS condition_code_key,
    --start_dt and stop_dt are varchar in format YYYY-mm-dd
    strftime(start_dt,'%Y%m%d')::INT AS start_date_key,
    COALESCE(strftime(stop_dt,'%Y%m%d')::INT, 99991231)  AS end_date_key
FROM {{ ref('stg_conditions') }} c
LEFT JOIN {{ ref('dim_code') }} dc
    ON c.condition_code = dc.code
    AND dc.code_system = 'SNOMED'