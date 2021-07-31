
FROM debian:buster

# DOCKER
# https://docs.docker.com/engine/install/debian/
RUN apt-get update && apt-get -y install --no-install-recommends \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg \
	lsb-release
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg	
RUN echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update && apt-get -y install --no-install-recommends \
	docker-ce docker-ce-cli containerd.io
RUN apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/man/?? /usr/share/man/??_*

# docker-compose
#RUN curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
RUN curl -L https://github.com/docker/compose/releases/download/1.25.3/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

RUN docker-compose --version


# OTRAS VAINAS
RUN apt-get update && apt-get -y install --no-install-recommends \
	wget \
	git \
	vim \
	net-tools \
	dirmngr \
	build-essential \
	manpages-dev \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/man/?? /usr/share/man/??_*

# ZSH 
# Default powerline10k theme, no plugins installed
# REQUIERE wget
RUN sh -c "$(wget --no-check-certificate -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)"



RUN printenv

#RUN mkdir /code && chown node:node /code
RUN mkdir /code
# copy in our source code last, as it changes the most
WORKDIR /code
COPY ./config /config/