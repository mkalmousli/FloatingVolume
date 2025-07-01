FROM debian:bookworm

RUN apt update
RUN apt install -y python3-minimal git \
                    unzip zip tar \
                    curl \
                    openjdk-11-jdk \
                    openjdk-11-jre
