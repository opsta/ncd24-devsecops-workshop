FROM python:3.13.0-alpine3.20

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY todo_app ./todo_app
COPY *.py .

EXPOSE 8000 8080

CMD python main.py
