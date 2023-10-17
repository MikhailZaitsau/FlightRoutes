FROM ruby:3.1.2-buster

ARG APP_ROOT=/flight_numbers

ENV BUNDLER_VERSION=2.4.7

RUN set -eux; \
    apt-get update; \
    apt-get -y upgrade; \
    apt-get install -y libpq-dev

RUN mkdir ${APP_ROOT}
WORKDIR ${APP_ROOT}

RUN gem install bundler:2.4.7

COPY Gemfile* ./

RUN bundle check || bundle install

ADD . ${APP_ROOT}

EXPOSE 3000

CMD [ "bundle","exec", "puma", "config.ru"]
