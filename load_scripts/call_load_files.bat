

SET MY_DB=HEALTH_ANALYTICS
SET MY_SCHEMA=DBT_AREIF_RAW
SET DATA_DIR=C:/Users/oakwo/Documents/Portfolio_Project/CBP_analysis/synthea_raw_csv/csv
SET DELETE_FIRST=1

"C:/Program Files/Snowflake CLI/snow" sql -c snowflake_trial -f load_files.sql ^
  -D db=%MY_DB% ^
  -D schema=%MY_SCHEMA% ^
  -D table=CONDITIONS ^
  -D local_file=%DATA_DIR%/conditions.csv ^
  -D file_name=conditions.csv^
  -D delete_first=%DELETE_FIRST%

"C:/Program Files/Snowflake CLI/snow" sql -c snowflake_trial -f load_files.sql ^
  -D db=%MY_DB% ^
  -D schema=%MY_SCHEMA% ^
  -D table=RAW_ENCOUNTERS ^
  -D local_file=%DATA_DIR%/encounters.csv ^
  -D file_name=encounters.csv^
  -D delete_first=%DELETE_FIRST%

"C:/Program Files/Snowflake CLI/snow" sql -c snowflake_trial -f load_files.sql ^
  -D db=%MY_DB% ^
  -D schema=%MY_SCHEMA% ^
  -D table=RAW_OBSERVATIONS ^
  -D local_file=%DATA_DIR%/observations.csv ^
  -D file_name=observations.csv^
  -D delete_first=%DELETE_FIRST%

"C:/Program Files/Snowflake CLI/snow" sql -c snowflake_trial   -f load_files.sql ^
  -D db=%MY_DB% ^
  -D schema=%MY_SCHEMA% ^
  -D table=RAW_ORGANIZATIONS ^
  -D local_file=%DATA_DIR%/organizations.csv ^
  -D file_name=organizations.csv^
  -D delete_first=%DELETE_FIRST%

"C:/Program Files/Snowflake CLI/snow" sql -c snowflake_trial -f load_files.sql ^
  -D db=%MY_DB% ^
  -D schema=%MY_SCHEMA% ^
  -D table=RAW_PATIENTS ^
  -D local_file=%DATA_DIR%/patients.csv ^
  -D file_name=patients.csv^
  -D delete_first=%DELETE_FIRST%

"C:/Program Files/Snowflake CLI/snow" sql -c snowflake_trial -f load_files.sql ^
  -D db=%MY_DB% ^
  -D schema=%MY_SCHEMA% ^
  -D table=RAW_PAYERS ^
  -D local_file=%DATA_DIR%/payers.csv ^
  -D file_name=payers.csv^
    -D delete_first=%DELETE_FIRST%


"C:/Program Files/Snowflake CLI/snow" sql -c snowflake_trial -f load_files.sql ^
  -D db=%MY_DB% ^
  -D schema=%MY_SCHEMA% ^
  -D table=RAW_PROVIDERS ^
  -D local_file=%DATA_DIR%/providers.csv ^
  -D file_name=providers.csv^
  -D delete_first=%DELETE_FIRST%