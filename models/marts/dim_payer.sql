SELECT 
    payer_id,
    payer_name,
    CASE WHEN payer_name IN ('Dual Eligible', 'Medicaid', 'Medicare')
        THEN payer_name
        WHEN payer_name = 'NO_INSURANCE'
        THEN 'No Insurance' 
        ELSE 'Commercial' END AS payer_type,
    CASE WHEN payer_name IN ('Dual Eligible', 'Medicaid', 'Medicare') 
        THEN 'Government' 
        WHEN payer_name = 'NO_INSURANCE' THEN 'No Insurance' 
        ELSE 'Commercial' END AS payer_ownership       
FROM {{ ref('stg_payers') }};

