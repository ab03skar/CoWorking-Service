FROM python:3.10-slim-buster

WORKDIR /src

COPY ./analytics/requirements.txt requirements.txt

RUN pip install -r requirements.txt

COPY ./analytics .

ENV DB_USERNAME=postgres \
    DB_PASSWORD=gqWESHly4E\
    DB_HOST=db-postgresql.default.svc.cluster.local \
    DB_PORT=5432 \
    DB_NAME=postgres

CMD python app.py

