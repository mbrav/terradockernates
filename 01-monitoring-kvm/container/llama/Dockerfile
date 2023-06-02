FROM python:3.11-bullseye

RUN apt upgrade -y && \
    apt install -y \
    curl \
    git \
    bash \
    # build-essential \
    # libssl-dev \
    # libffi-dev \
    # python3-dev \
    && curl -fsSL https://deb.nodesource.com/setup_19.x | bash - && \
    apt install -y nodejs && \ 
    apt clean

RUN git clone --depth 1 --branch 0.1.0 https://github.com/cocktailpeanut/dalai.git

WORKDIR dalai

COPY ./container/llama/entrypoint.sh /usr/local/bin/

ENTRYPOINT [ "entrypoint.sh" ]
