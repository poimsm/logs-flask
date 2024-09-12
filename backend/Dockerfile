FROM python:3.10.5-bullseye

RUN apt-get clean all
RUN apt-get update

RUN apt-get install -y vim curl netcat

RUN pip install --upgrade pip

COPY ./backend /app

WORKDIR /app

RUN pip install -r requirements.txt

RUN chmod +x entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
