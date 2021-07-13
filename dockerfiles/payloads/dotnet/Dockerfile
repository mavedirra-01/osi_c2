FROM mono:latest

ARG CA_CERTIFICATE
ARG NPM_REGISTRY
ARG PYPI_INDEX
ARG PYPI_INDEX_URL
ARG DOCKER_REGSITRY_MIRROR
ARG HTTP_PROXY
ARG HTTPS_PROXY

RUN apt-get update && apt-get install software-properties-common apt-utils make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev -y
COPY compile.sh . 
RUN chmod +x compile.sh && mv compile.sh /bin/
