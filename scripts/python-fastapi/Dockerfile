FROM python:3.13.0-alpine3.20

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY *.py .

EXPOSE 8000

CMD ["python", "main.py"]
