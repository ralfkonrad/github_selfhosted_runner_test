FROM ubuntu:22.04

#input GitHub runner version argument
ARG RUNNER_VERSION
ENV DEBIAN_FRONTEND=noninteractive

LABEL Author=ralfkonrad
LABEL GitHub="https://github.com/ralfkonrad"
LABEL BaseImage="ubuntu:22.04"
LABEL RunnerVersion=${RUNNER_VERSION}

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends ca-certificates \
                                               curl \
                                               dotnet-runtime-6.0 \
                                               git \
                                               jq \
                                               unzip \
                                               wget && \
    update-ca-certificates

RUN groupadd docker && \
    useradd -g docker -m docker
WORKDIR /home/docker

RUN mkdir actions-runner && \
    cd actions-runner && \
    curl -o actions-runner-linux-x64.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    tar xzf ./actions-runner-linux-x64.tar.gz && \
    rm ./actions-runner-linux-x64.tar.gz

ADD ./scripts/start.sh ./start.sh
RUN pwd && \
    chmod +x ./start.sh && \
    chown -R docker . && \
    ls -lah **

USER docker

ENTRYPOINT [ "./start.sh" ]
