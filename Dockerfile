FROM node:10
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install locales-all lsb-release wget gnupg2 apt-utils tmux nginx -y --no-install-recommends &&\
    mkdir -p /opt/app/scripts/ && rm etc/nginx/sites-enabled/*
COPY fakewhatsapp /etc/nginx/sites-enabled/