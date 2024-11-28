FROM python:3.11.3-alpine3.18

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY *.py .

EXPOSE 8000

CMD ["python", "main.py"]
