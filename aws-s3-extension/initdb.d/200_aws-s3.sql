-- An helper function to mitigate slight schema differences between databases in different environments
CREATE OR REPLACE FUNCTION table_columns(varchar) RETURNS varchar
LANGUAGE SQL AS $$
    SELECT string_agg(column_name, ',')
    FROM (
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = $1
        ORDER BY column_name
    ) _
$$;

-- Procedure to export result of query to S3
CREATE OR REPLACE PROCEDURE s3_export(
    query varchar,
    "path" varchar
)
LANGUAGE plpgsql AS $$
BEGIN
    RAISE NOTICE 'Exporting result of query (%) to S3 (%)', query, "path";
    PERFORM aws_s3.query_export_to_s3(
        query := query,
        file_path := "path",
        options := 'FORMAT CSV, HEADER',
        -- ! TODO: These values are sure sensitive, but hard-coded here for demonstration purposes
        bucket := 'bucket',
        region := NULL,
        access_key := 'user',
        secret_key := 'password',
        session_token := NULL,
        endpoint_url := 'http://minio:9000'
    );
END
$$;

-- Procedure to import file in S3 to table
CREATE OR REPLACE PROCEDURE s3_import(
    "table" varchar,
    "path" varchar,
    "columns" varchar DEFAULT NULL
)
LANGUAGE plpgsql AS $$
BEGIN
    IF "columns" IS NULL THEN
        "columns" := table_columns("table");
    END IF;

    RAISE NOTICE 'Importing file in S3 (%) to table (%)', "path", "table";
    PERFORM aws_s3.table_import_from_s3(
        table_name := "table",
        file_path := "path",
        column_list := "columns",
        options := '(FORMAT CSV, HEADER)',
        -- ! TODO: These values are sure sensitive, but hard-coded here for demonstration purposes
        bucket := 'bucket',
        region := NULL,
        access_key := 'user',
        secret_key := 'password',
        session_token := NULL,
        endpoint_url := 'http://minio:9000'
    );
END
$$
