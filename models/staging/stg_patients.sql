with

source as (
  
    select * from {{ source('synthea','patients') }}

),

renamed as (

    select

        ----------  ids
        id as patient_id,
        first || ' ' || last as patient_full_name,  
        birthdate as patient_birthdate,
        deathdate as patient_deathdate,
        marital as patient_marital_status,
        race as patient_race,
        ethnicity as patient_ethnicity,
        gender as patient_gender,
        address as patient_address,
        city as patient_city,
        state as patient_state,
        county as patient_county,
        zip as patient_zip,
        lat as patient_latitude,
        lon as patient_longitude,


    from source

)

select * from renamed