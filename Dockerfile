
FROM ubuntu:18.04

RUN printenv

ENV NODE_ENV=${NODE_ENV}
ENV NODE_VERSION=12.22.12

RUN apt-get update && apt-get -y install --no-install-recommends \
	curl \
	wget \
	git \
	vim \
	net-tools \
	dirmngr \
	gnupg \
	apt-transport-https \
	ca-certificates \
	software-properties-common \
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

# nodejs
RUN echo $NODE_VERSION
RUN echo ${NODE_VERSION}
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"


# Default powerline10k theme, no plugins installed
RUN sh -c "$(wget --no-check-certificate -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)"

#RUN mkdir /code && chown node:node /code
RUN mkdir /code
# copy in our source code last, as it changes the most
WORKDIR /code

# PORT FOR ANGULAR APP 
EXPOSE 4200

COPY ./config /config/