FROM ruby:2.7.2
RUN apt-get update -qq && apt-get clean
RUN mkdir -p /usr/src/app/remitano_server
WORKDIR /usr/src/app/remitano_server
ADD Gemfile Gemfile.lock ./
RUN bundle install
COPY . ./
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]