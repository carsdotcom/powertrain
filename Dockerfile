FROM ubuntu:latest

MAINTAINER Mac Heller-Ogden <mheller-ogden@cars.com>

ENV REFRESHED_AT 2015-12-10

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y wget \
    make

WORKDIR /app
COPY . /app

RUN chmod +x /app/powertrain
RUN chmod +x /app/*.sh
RUN chmod +x /app/**/*.sh

ENTRYPOINT [ "/app/powertrain" ]
