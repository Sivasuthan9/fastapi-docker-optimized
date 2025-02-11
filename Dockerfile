FROM python:3.10-slim

WORKDIR /app

COPY . /app/

RUN pip install poetry 

RUN poetry install --no-root --without dev

EXPOSE 8000

CMD ["poetry", "run", "python", "server.py"]
