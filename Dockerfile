FROM debian:bookworm

RUN apt update
RUN apt install -y python3-minimal git \
                    unzip zip tar \
                    curl bash

RUN curl -s "https://get.sdkman.io" | bash
RUN bash -c "source /root/.sdkman/bin/sdkman-init.sh && sdk install java 11.0.20-tem"
