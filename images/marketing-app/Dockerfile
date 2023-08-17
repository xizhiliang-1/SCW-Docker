FROM python:3.8-alpine

WORKDIR /app

COPY src/code/requirements.txt .

RUN mount=type=cache,target=/root/.cache/pip \
    pip install -r requirements.txt

COPY run.sh /

COPY src/code/ .

RUN adduser -D nonroot

RUN chown -R nonroot /app

USER nonroot

EXPOSE 8081

CMD ["/bin/sh", "/run.sh"]
