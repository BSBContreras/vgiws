FROM python:3.8.5-slim-buster

# use it to avoid unnecessaries warnings
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /app

ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    TZ=America/Sao_Paulo

COPY ./requirements.txt ./

RUN apt-get update && \
    # install it to avoid unnecessaries warnings
    apt-get install -y --no-install-recommends apt-utils && \
    # psycopg dependencies
    apt-get install -y --no-install-recommends gcc python3-dev libpq-dev && \
    # GDAL
    apt-get install -y --no-install-recommends python3-gdal gdal-bin && \
    # service requirements
    pip install -r requirements.txt

EXPOSE 8888

CMD [ "python", "main.py" ]
