SELECT aws_s3.table_import_from_s3(
    table_name := 'store',
    column_list := '',
    options := '(FORMAT CSV, HEADER)',
    bucket := 'bucket',
    file_path := 'store.csv',
    region := NULL,
    access_key := 'user',
    secret_key := 'password',
    session_token := NULL,
    endpoint_url := 'http://minio:9000'
);
