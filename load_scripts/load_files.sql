-- Variables are passed at runtime with -D (see the run command below):
--   local_file : full local path, e.g. /data/orders.csv
--   file_name  : base name of that file, e.g. orders.csv
--   table      : existing target table

/*
USAGE:
snow sql -c my_connection -f load_file.sql \
  -D db=MY_DB \
  -D schema=MY_SCHEMA \
  -D table=ORDERS \
  -D local_file=/data/orders.csv \
  -D file_name=orders.csv \
  -D delete_first=1
*/

USE WAREHOUSE TRANSFORMING;
USE DATABASE <% db %>;
USE SCHEMA <% schema %>;

-- One-time objects (safe to re-run)
CREATE FILE FORMAT IF NOT EXISTS my_csv_format
  TYPE = CSV
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  NULL_IF = ('', 'NULL');

CREATE STAGE IF NOT EXISTS my_internal_stage
  FILE_FORMAT = my_csv_format;

-- Upload the local file to the stage (gzips it automatically)
PUT file://<% local_file %> @my_internal_stage/<% table %>
  AUTO_COMPRESS = TRUE
  OVERWRITE = TRUE;

--delete from the table if delete_first flag is set to 1
EXECUTE IMMEDIATE $$
BEGIN
IF (<% delete_first %>=1) THEN
  -- Optional: delete existing data in the target table before loading
  DELETE FROM <% table %>;
END IF;
END;
$$;


-- Load into the existing raw data table
COPY INTO <% table %>
  FROM @my_internal_stage/<% table %>
  PATTERN = '.*<% file_name %>.gz'
  FILE_FORMAT = (FORMAT_NAME = my_csv_format)
  ON_ERROR = ABORT_STATEMENT
  FORCE = TRUE;

-- Optional: clean up the staged file after a successful load
REMOVE @my_internal_stage PATTERN = '.*<% file_name %>.gz';