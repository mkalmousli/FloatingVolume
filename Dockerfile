FROM debian:bookworm

RUN apt update
RUN apt install -y python3-minimal git \
                    unzip zip tar \
                    default-jre \
                    curl
