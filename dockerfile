FROM ubuntu:22.04

#input GitHub runner version argument
ARG RUNNER_VERSION

ARG USER=github-agent
ARG GROUP=github-agent
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

RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
            $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update -y && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

RUN groupadd ${GROUP} && \
    useradd -g ${GROUP} -m ${USER}
WORKDIR /home/${USER}

RUN mkdir actions-runner && \
    cd actions-runner && \
    curl -o actions-runner-linux-x64.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    tar xzf ./actions-runner-linux-x64.tar.gz && \
    rm ./actions-runner-linux-x64.tar.gz

ADD ./scripts/start.sh ./start.sh
RUN pwd && \
    chmod +x ./start.sh && \
    chown -R github-agent . && \
    ls -lah **

USER ${USER}

ENTRYPOINT [ "./start.sh" ]
