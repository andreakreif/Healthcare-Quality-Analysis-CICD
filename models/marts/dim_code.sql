SELECT 'SNOMED_'|| condition_code AS code_key,
    condition_code AS code, 
    MAX(condition_description) AS code_description,
    'SNOMED' AS code_system
FROM {{ ref('stg_conditions') }}
GROUP BY condition_code
UNION ALL
SELECT 'LOINC_'|| observation_code AS code_key,
    observation_code as code, 
    MAX(observation_description) AS code_description, 
    'LOINC' AS code_system
FROM {{ ref('stg_observations'  ) }}
GROUP BY observation_code