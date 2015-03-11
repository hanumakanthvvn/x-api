FROM ruby:2.1.5

RUN mkdir /x-api

WORKDIR /x-api

ADD Gemfile /x-api/Gemfile

ADD Gemfile.lock /x-api/Gemfile.lock

RUN gem install foreman

RUN bundle install --without development test

