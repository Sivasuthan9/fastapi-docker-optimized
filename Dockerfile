FROM python:3.11-slim

WORKDIR /app

COPY . /app/

RUN sudo apt update && sudo apt install -y poetry 

RUN poetry install --no-dev --no-root

EXPOSE 8000

CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8000"]
