FROM ruby:2.7.3-alpine
RUN apk add \
    build-base \
    postgresql-dev \
    tzdata \
    nodejs \
    yarn
WORKDIR /app
COPY Gemfile* .
RUN bundle install
RUN bundle exec rails webpacker:install
RUN yarn add jquery popper.js
COPY . .
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
