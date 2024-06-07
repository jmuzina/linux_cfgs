FROM ubuntu:noble
LABEL authors="jmuzina"

RUN apt-get update && \
    apt-get upgrade -y \
    && apt-get install sudo -y

COPY install.sh .
RUN chmod +x install.sh
RUN ./install.sh