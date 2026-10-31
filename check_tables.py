#usage python check_tables.py
import duckdb

con = duckdb.connect("dev.duckdb", read_only=True)
con.sql("""
    select table_schema, table_name
    from information_schema.tables
    where table_schema not in ('information_schema', 'pg_catalog')
    order by 1, 2
""").show()
con.close()