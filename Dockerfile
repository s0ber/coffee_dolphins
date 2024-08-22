# syntax=docker/dockerfile:1

FROM ruby:2.1.10 AS base

# fix some old debian repos
RUN rm /etc/apt/sources.list
RUN echo "deb http://archive.debian.org/debian-security jessie/updates main" >> /etc/apt/sources.list.d/jessie.list
RUN echo "deb http://archive.debian.org/debian jessie main" >> /etc/apt/sources.list.d/jessie.list

RUN apt-get update -qq
RUN apt-get install -y --force-yes imagemagick libmagickwand-dev

ENV PATH="/usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16:$PATH"

WORKDIR '/app'

COPY Gemfile* .
COPY gems gems

RUN bundle install

# install old node
SHELL ["/bin/bash", "--login", "-c"]
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
RUN nvm install 1

COPY .bowerrc bower.json .

RUN npm install -g bower
RUN rm -rf vendor/assets/components && bower install --config.interactive=false

ENV PORT=3000

EXPOSE $PORT

# What the container should run when it is started.
CMD ["bundle", "exec", "foreman", "start"]
