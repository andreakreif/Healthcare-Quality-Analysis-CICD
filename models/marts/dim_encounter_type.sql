{{ config(materialized='table') }}

with source_types as (

    -- One row per class + code. MAX() guards against a code carrying
    -- more than one description in the source.
    select
        lower(encounter_class)         as encounter_class,
        encounter_code,
        max(encounter_description)     as encounter_description
    from {{ ref('stg_encounters') }}
    group by 1, 2

),

mapped as (

    select
        {{ dbt_utils.generate_surrogate_key(['s.encounter_class', 's.encounter_code']) }}
                                       as encounter_type_key,
        s.encounter_class,
        s.encounter_code,
        s.encounter_description,
        m.care_setting,
        m.is_qualifying_visit,
        m.is_attribution_visit,
        m.is_acute,
        m.is_hospice
    from source_types s
    left join {{ ref('encounter_class_map') }} m
        on m.encounter_class = s.encounter_class

),

unknown_row as (

    select
        '-1'      as encounter_type_key,
        'unknown' as encounter_class,
        'unknown' as encounter_code,
        'Unknown' as encounter_description,
        'Unknown' as care_setting,
        false     as is_qualifying_visit,
        false     as is_attribution_visit,
        false     as is_acute,
        false     as is_hospice

)

select * from mapped
union all
select * from unknown_row