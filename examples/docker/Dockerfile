FROM ruby
MAINTAINER Fiona Hasanaj

# install necessary software
RUN apt-get -y update && apt-get install -y \
    vim  \
    git

RUN gem install rubysl-securerandom \
    rspec \
    webmock \
    simplecov \
    tomdoc

RUN mkdir /ruby-dev
WORKDIR /ruby-dev
COPY run_ruby.sh run_ruby.sh
RUN chmod 0755 run_ruby.sh

# allow interactive bash inside docker container
CMD ./run_ruby.sh $API_KEY $FILENAME $ALT_URL 

VOLUME ["/source"]
