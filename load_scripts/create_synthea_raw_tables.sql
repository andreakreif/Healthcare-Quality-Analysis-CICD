-- =============================================================================
-- Synthea sample data (Apr 2020 CSV export) - raw table DDL for Snowflake
-- Target: HEALTH_ANALYTICS.DBT_AREIF_RAW
--
-- Notes
--   * Synthea timestamps look like 2010-01-23T17:45:28Z (UTC). They are stored
--     as TIMESTAMP_NTZ; load them with the file format below.
--   * Clinical codes (SNOMED, LOINC, CVX, RxNorm) are VARCHAR on purpose:
--     LOINC codes contain hyphens (8302-2) and numeric codes should never lose
--     leading zeros or be used in arithmetic.
--   * PRIMARY KEY constraints are informational only in Snowflake (not enforced).
--   * Empty CSV fields load as NULL via NULL_IF / EMPTY_FIELD_AS_NULL.
-- =============================================================================

USE DATABASE HEALTH_ANALYTICS;
USE SCHEMA DBT_AREIF_RAW;

-- File format for all Synthea CSVs
CREATE FILE FORMAT IF NOT EXISTS SYNTHEA_CSV_FORMAT
  TYPE = CSV
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  EMPTY_FIELD_AS_NULL = TRUE
  NULL_IF = ('')
  DATE_FORMAT = 'YYYY-MM-DD'
  TIMESTAMP_FORMAT = 'YYYY-MM-DD"T"HH24:MI:SS"Z"';

-- -----------------------------------------------------------------------------
-- Reference / dimension-like tables
-- -----------------------------------------------------------------------------

-- patients.csv
CREATE TABLE IF NOT EXISTS RAW_PATIENTS (
    ID                    VARCHAR(36)   NOT NULL PRIMARY KEY,
    BIRTHDATE             DATE          NOT NULL,
    DEATHDATE             DATE,
    SSN                   VARCHAR(11),
    DRIVERS               VARCHAR(20),
    PASSPORT              VARCHAR(20),
    PREFIX                VARCHAR(10),
    FIRST                 VARCHAR(50),
    LAST                  VARCHAR(50),
    SUFFIX                VARCHAR(10),
    MAIDEN                VARCHAR(50),
    MARITAL               VARCHAR(1),
    RACE                  VARCHAR(20),
    ETHNICITY             VARCHAR(20),
    GENDER                VARCHAR(1),
    BIRTHPLACE            VARCHAR(150),
    ADDRESS               VARCHAR(100),
    CITY                  VARCHAR(50),
    STATE                 VARCHAR(30),
    COUNTY                VARCHAR(50),
    ZIP                   VARCHAR(10),
    LAT                   FLOAT,
    LON                   FLOAT,
    HEALTHCARE_EXPENSES   NUMBER(14,2),
    HEALTHCARE_COVERAGE   NUMBER(14,2)
);

-- organizations.csv
CREATE TABLE IF NOT EXISTS RAW_ORGANIZATIONS (
    ID                    VARCHAR(36)   NOT NULL PRIMARY KEY,
    NAME                  VARCHAR(150),
    ADDRESS               VARCHAR(100),
    CITY                  VARCHAR(50),
    STATE                 VARCHAR(2),
    ZIP                   VARCHAR(10),
    LAT                   NUMBER(9,6),
    LON                   NUMBER(9,6),
    PHONE                 VARCHAR(30),
    REVENUE               NUMBER(14,2),
    UTILIZATION           NUMBER(10,0)
);

-- providers.csv
CREATE TABLE IF NOT EXISTS RAW_PROVIDERS (
    ID                    VARCHAR(36)   NOT NULL PRIMARY KEY,
    ORGANIZATION          VARCHAR(36),                 -- ORGANIZATIONS.ID
    NAME                  VARCHAR(100),
    GENDER                VARCHAR(1),
    SPECIALITY            VARCHAR(100),                -- spelling matches source column
    ADDRESS               VARCHAR(100),
    CITY                  VARCHAR(50),
    STATE                 VARCHAR(2),
    ZIP                   VARCHAR(10),
    LAT                   NUMBER(9,6),
    LON                   NUMBER(9,6),
    UTILIZATION           NUMBER(10,0)
);

-- payers.csv
CREATE TABLE IF NOT EXISTS RAW_PAYERS (
    ID                       VARCHAR(36)   NOT NULL PRIMARY KEY,
    NAME                     VARCHAR(100),
    ADDRESS                  VARCHAR(100),
    CITY                     VARCHAR(50),
    STATE_HEADQUARTERED      VARCHAR(2),
    ZIP                      VARCHAR(10),
    PHONE                    VARCHAR(30),
    AMOUNT_COVERED           NUMBER(14,2),
    AMOUNT_UNCOVERED         NUMBER(14,2),
    REVENUE                  NUMBER(14,2),
    COVERED_ENCOUNTERS       NUMBER(10,0),
    UNCOVERED_ENCOUNTERS     NUMBER(10,0),
    COVERED_MEDICATIONS      NUMBER(10,0),
    UNCOVERED_MEDICATIONS    NUMBER(10,0),
    COVERED_PROCEDURES       NUMBER(10,0),
    UNCOVERED_PROCEDURES     NUMBER(10,0),
    COVERED_IMMUNIZATIONS    NUMBER(10,0),
    UNCOVERED_IMMUNIZATIONS  NUMBER(10,0),
    UNIQUE_CUSTOMERS         NUMBER(10,0),
    QOLS_AVG                 FLOAT,
    MEMBER_MONTHS            NUMBER(10,0)
);
/*
-- payer_transitions.csv
CREATE TABLE IF NOT EXISTS RAW_PAYER_TRANSITIONS (
    PATIENT               VARCHAR(36)   NOT NULL,      -- PATIENTS.ID
    START_YEAR            NUMBER(4,0),
    END_YEAR              NUMBER(4,0),
    PAYER                 VARCHAR(36),                 -- PAYERS.ID
    OWNERSHIP             VARCHAR(20)
);
*/
-- -----------------------------------------------------------------------------
-- Encounter + clinical fact tables
-- -----------------------------------------------------------------------------

-- encounters.csv
CREATE TABLE IF NOT EXISTS RAW_ENCOUNTERS (
    ID                    VARCHAR(36)   NOT NULL PRIMARY KEY,
    START_TS                 TIMESTAMP_NTZ,
    STOP_TS                  TIMESTAMP_NTZ,
    PATIENT               VARCHAR(36),                 -- PATIENTS.ID
    ORGANIZATION          VARCHAR(36),                 -- ORGANIZATIONS.ID
    PROVIDER              VARCHAR(36),                 -- PROVIDERS.ID
    PAYER                 VARCHAR(36),                 -- PAYERS.ID
    ENCOUNTERCLASS        VARCHAR(20),
    CODE                  VARCHAR(20),
    DESCRIPTION           VARCHAR(255),
    BASE_ENCOUNTER_COST   NUMBER(12,2),
    TOTAL_CLAIM_COST      NUMBER(12,2),
    PAYER_COVERAGE        NUMBER(12,2),
    REASONCODE            VARCHAR(20),
    REASONDESCRIPTION     VARCHAR(255)
);
/*
-- allergies.csv
CREATE TABLE IF NOT EXISTS RAW_ALLERGIES (
    START_DT                DATE,
    STOP_DT                 DATE,
    PATIENT               VARCHAR(36),
    ENCOUNTER             VARCHAR(36),
    CODE                  VARCHAR(20),
    DESCRIPTION           VARCHAR(255)
);

-- careplans.csv
CREATE TABLE IF NOT EXISTS RAW_CAREPLANS (
    ID                    VARCHAR(36)   NOT NULL PRIMARY KEY,
    START_DT                 DATE,
    STOP_DT                  DATE,
    PATIENT               VARCHAR(36),
    ENCOUNTER             VARCHAR(36),
    CODE                  VARCHAR(20),
    DESCRIPTION           VARCHAR(255),
    REASONCODE            VARCHAR(20),
    REASONDESCRIPTION     VARCHAR(255)
);
*/
-- conditions.csv
CREATE TABLE IF NOT EXISTS RAW_CONDITIONS (
    START_DT                DATE,
    STOP_DT                  DATE,
    PATIENT               VARCHAR(36),
    ENCOUNTER             VARCHAR(36),
    CODE                  VARCHAR(20),
    DESCRIPTION           VARCHAR(255)
);
/*
-- devices.csv
CREATE TABLE IF NOT EXISTS RAW_DEVICES (
    START_TS                 TIMESTAMP_NTZ,
    STOP_TS                  TIMESTAMP_NTZ,
    PATIENT               VARCHAR(36),
    ENCOUNTER             VARCHAR(36),
    CODE                  VARCHAR(20),
    DESCRIPTION           VARCHAR(255),
    UDI                   VARCHAR(150)
);

-- imaging_studies.csv
CREATE TABLE IF NOT EXISTS  IMAGING_STUDIES (
    ID                    VARCHAR(36)   NOT NULL,      -- unique in this sample, but Synthea can emit multiple rows per study, so no PK
    DATE_TS                  TIMESTAMP_NTZ,
    PATIENT               VARCHAR(36),
    ENCOUNTER             VARCHAR(36),
    BODYSITE_CODE         VARCHAR(20),
    BODYSITE_DESCRIPTION  VARCHAR(100),
    MODALITY_CODE         VARCHAR(10),
    MODALITY_DESCRIPTION  VARCHAR(50),
    SOP_CODE              VARCHAR(50),
    SOP_DESCRIPTION       VARCHAR(100)
);

-- immunizations.csv
CREATE TABLE IF NOT EXISTS RAW_IMMUNIZATIONS (
    DATE_TS                 TIMESTAMP_NTZ,
    PATIENT               VARCHAR(36),
    ENCOUNTER             VARCHAR(36),
    CODE                  VARCHAR(10),
    DESCRIPTION           VARCHAR(255),
    BASE_COST             NUMBER(12,2)
);

-- medications.csv
CREATE TABLE IF NOT EXISTS MEDICATIONS (
    START_TS                 TIMESTAMP_NTZ,
    STOP_TS                 TIMESTAMP_NTZ,
    PATIENT               VARCHAR(36),
    PAYER                 VARCHAR(36),
    ENCOUNTER             VARCHAR(36),
    CODE                  VARCHAR(20),
    DESCRIPTION           VARCHAR(255),
    BASE_COST             NUMBER(12,2),
    PAYER_COVERAGE        NUMBER(12,2),
    DISPENSES             NUMBER(10,0),
    TOTALCOST             NUMBER(14,2),
    REASONCODE            VARCHAR(20),
    REASONDESCRIPTION     VARCHAR(255)
);
*/
-- observations.csv
-- VALUE is VARCHAR because TYPE = 'text' rows hold free text alongside
-- TYPE = 'numeric' rows; cast with TRY_TO_NUMBER(VALUE) downstream.
CREATE TABLE IF NOT EXISTS RAW_OBSERVATIONS (
    DATE_TS                  TIMESTAMP_NTZ,
    PATIENT               VARCHAR(36),
    ENCOUNTER             VARCHAR(36),                 -- nullable in source
    CODE                  VARCHAR(20),
    DESCRIPTION           VARCHAR(255),
    VALUE                 VARCHAR(255),
    UNITS                 VARCHAR(50),
    TYPE                  VARCHAR(20)
);
/*
-- procedures.csv
CREATE TABLE IF NOT EXISTS RAW_PROCEDURES (
    DATE                  TIMESTAMP_NTZ,
    PATIENT               VARCHAR(36),
    ENCOUNTER             VARCHAR(36),
    CODE                  VARCHAR(20),
    DESCRIPTION           VARCHAR(255),
    BASE_COST             NUMBER(12,2),
    REASONCODE            VARCHAR(20),
    REASONDESCRIPTION     VARCHAR(255)
);

-- supplies.csv (empty in this sample export, but the structure is defined)
CREATE TABLE IF NOT EXISTS RAW_SUPPLIES (
    DATE                  DATE,
    PATIENT               VARCHAR(36),
    ENCOUNTER             VARCHAR(36),
    CODE                  VARCHAR(20),
    DESCRIPTION           VARCHAR(255),
    QUANTITY              NUMBER(10,0)
);
*/