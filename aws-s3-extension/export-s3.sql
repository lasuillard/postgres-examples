SELECT * FROM aws_s3.query_export_to_s3(
    query := 'select * from store',
    bucket := 'bucket',
    file_path := 'store.csv',
    region := NULL,
    access_key := 'user',
    secret_key := 'password',
    session_token := NULL,
    options := 'FORMAT CSV, HEADER',
    endpoint_url := 'http://minio:9000'
);
