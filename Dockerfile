FROM postgres:16-bullseye

RUN apt-get update && apt-get install -y \
    git \
    postgresql-plpython3-16 \
    python3-pip \
    unzip \
    wget \
    && apt-get clean

ENV PIP_NO_CACHE_DIR="off"
RUN pip3 install boto3

# Install S3 extension (https://github.com/chimpler/postgres-aws-s3)
RUN git clone https://github.com/chimpler/postgres-aws-s3 /tmp/postgres-aws-s3 \
    && cd /tmp/postgres-aws-s3 \
    && git checkout 4f601abf6960e929db672b46161fcc4313b80959 \
    && make install \
    && cd - \
    && rm -rf /tmp/postgres-aws-s3

COPY ./initdb.d/* /docker-entrypoint-initdb.d/
