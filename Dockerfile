FROM python:3.9.11

WORKDIR /code

COPY requirements.txt .

RUN pip install -r ./requirements.txt


COPY server.py .

EXPOSE 8080
CMD [ "python", "./server.py" ]

