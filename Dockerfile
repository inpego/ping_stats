FROM ruby:2.7.0
RUN mkdir /app
COPY . /app
WORKDIR /app
COPY config/database.yml.sample config/database.yml
RUN gem install bundler -v 2.1.4
RUN bundle install
ENTRYPOINT './entrypoint.sh'
