SET MY_DB=HEALTH_ANALYTICS
SET MY_SCHEMA=DBT_AREIF_RAW
SET DATA_DIR=C:/Users/oakwo/Documents/Portfolio_Project/CBP_analysis/synthea_raw_csv/csv
SET DELETE_FIRST=1

"C:/Program Files/Snowflake CLI/snow" sql -c snowflake_trial -f load_files.sql ^
  -D db=%MY_DB% ^
  -D schema=%MY_SCHEMA% ^
  -D table=RAW_OBSERVATIONS ^
  -D local_file=%DATA_DIR%/observations.csv ^
  -D file_name=observations.csv^
  -D delete_first=%DELETE_FIRST%