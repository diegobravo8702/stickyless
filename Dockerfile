FROM ubuntu:18.04

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \
    GOPATH=/root/go \
    PATH="${PATH}:/root/go/bin:/usr/local/go/bin"


RUN printenv

RUN apt-get update && apt-get -y install --no-install-recommends \
    curl \
    git \
    vim \
    apt-transport-https \
	ca-certificates \
	software-properties-common \
    gpg-agent \
	&& curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
	&& add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" \
	&& apt-get update \
	&& apt-cache policy docker-ce \
	&& apt-get install -y docker-ce \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/man/?? /usr/share/man/??_*


# docker-compose
RUN curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# zsh theme
# Default powerline10k theme, no plugins installed
RUN sh -c "$(wget --no-check-certificate -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)"


# go
RUN curl -O https://dl.google.com/go/go1.12.1.linux-amd64.tar.gz
RUN tar -xvf go1.12.1.linux-amd64.tar.gz -C /usr/local
RUN chown -R root:root /usr/local/go

#RUN mkdir /code && chown node:node /code
RUN mkdir /code
# copy in our source code last, as it changes the most
WORKDIR /code
COPY ./config /config/
