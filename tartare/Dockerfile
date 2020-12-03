FROM python:3.6.5-slim-stretch

ARG DOCKER_VERSION="5:19.03.13~3-0~debian-stretch"

RUN BUILD_DEPENDENCIES="apt-transport-https ca-certificates curl gnupg-agent software-properties-common" \
    && apt-get update \
    && apt-get --yes install \
        # used in docker_wrapper.py for waiting until a container is up (wiremock)
        wget \
        make \
        ${BUILD_DEPENDENCIES} \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get -y install docker-ce-cli=${DOCKER_VERSION} \
    && apt-get -y purge ${BUILD_DEPENDENCIES} \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*


ENV PIP_TARGET=/tmp/pip
ENV PYTHONPATH=${PYTHONPATH}:/tmp/pip
ENV PATH=${PATH}:/tmp/pip/bin
