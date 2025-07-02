FROM debian:bookworm

RUN apt update
RUN apt install -y python3-minimal git \
                    unzip zip tar \
                    curl bash

RUN apt install -y default-jre