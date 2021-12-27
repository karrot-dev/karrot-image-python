FROM debian:buster

RUN apt-get update && \
    apt-get install -y \
        curl \
        gnupg \
        gnupg1 \
        gnupg2 \
        python3.7 \
        python3.7-dev \
        virtualenv \
        build-essential \
        git \
        wget \
        rsync \
        python3-pip \
        entr \
        binutils \
        libproj-dev \
        gdal-bin \
        zip \
    && apt clean

# https://github.com/nodesource/distributions/blob/master/README.md#deb
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && apt-get install -y nodejs

RUN curl -o /usr/local/bin/circleci \
        https://circle-downloads.s3.amazonaws.com/releases/build_agent_wrapper/circleci && \
    chmod +x /usr/local/bin/circleci

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > \
      /etc/apt/sources.list.d/yarn.list  

RUN apt-get update && \
    apt-get install -y \
        yarn \
    && apt clean                

RUN pip3 install pip-tools
COPY requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt

ENV HUB_VERSION=2.14.2

RUN wget https://github.com/github/hub/releases/download/v${HUB_VERSION}/hub-linux-amd64-${HUB_VERSION}.tgz && \
    tar -xf hub-linux-amd64-${HUB_VERSION}.tgz && \
    ./hub-linux-amd64-${HUB_VERSION}/install && \
    rm hub-linux-amd64-${HUB_VERSION}.tgz && \
    rm -r hub-linux-amd64-${HUB_VERSION}

ENV MDBOOK_VERSION=0.4.14

RUN wget https://github.com/rust-lang/mdBook/releases/download/v${MDBOOK_VERSION}/mdbook-v${MDBOOK_VERSION}-x86_64-unknown-linux-gnu.tar.gz && \
    tar -xf mdbook-v${MDBOOK_VERSION}-x86_64-unknown-linux-gnu.tar.gz && \
    rm mdbook-v${MDBOOK_VERSION}-x86_64-unknown-linux-gnu.tar.gz && \
    mv mdbook /usr/local/bin
