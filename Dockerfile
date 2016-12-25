FROM ruby:2.2.6-slim

ADD Gemfile /app/
ADD Gemfile.lock /app/
RUN apt-get update -qq && \
    apt-get install -y build-essential && \
    gem install bundler --no-ri --no-rdoc && \
    cd /app ; bundle install --without development test
ADD . /app
RUN chown -R nobody:nogroup /app
USER nobody
ENV RACK_ENV production
EXPOSE 3000
WORKDIR /app
CMD ["bundle", "exec", "thin", "start"]
