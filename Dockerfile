FROM python:3.10-slim

WORKDIR /app

COPY . /app/

RUN pip install poetry

ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

RUN poetry install --no-root --without dev --no-cache && rm -rf $POETRY_CACHE_DIR

EXPOSE 8000

CMD ["poetry", "run", "python", "server.py"]
