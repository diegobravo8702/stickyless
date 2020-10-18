# if you're doing anything beyond your local machine, please pin this to a specific version at https://hub.docker.com/_/node/
# FROM node:12-alpine also works here for a smaller image
FROM node:12-slim

ENV NODE_ENV $NODE_ENV

# you'll likely want the latest npm, regardless of node version, for speed and fixes
# but pin this version for the best stability
RUN npm i npm@latest -g

RUN apt-get -y update && apt-get -y install  --no-install-recommends \
    git \
    gnupg \
    vim \
    wget \
    net-tools \
    dirmngr \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/man/?? /usr/share/man/??_*
# Default powerline10k theme, no plugins installed
RUN sh -c "$(wget --no-check-certificate -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)"

#RUN mkdir /code && chown node:node /code
# copy in our source code last, as it changes the most
WORKDIR /code
COPY . /code