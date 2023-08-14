FROM python:3.9.11

WORKDIR /code

COPY requirements.txt .

RUN pip install -r ./requirements.txt


COPY server.py .


CMD [ "python", "./server.py" ]

