FROM ruby:2.6.3-alpine3.9
MAINTAINER Ash Wilson <smashwilson@gmail.com>

COPY ./main.rb /main.rb

CMD ["/main.rb"]