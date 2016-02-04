FROM ruby:2.2.0
MAINTAINER Fiona Hasanaj

# install necessary software
RUN apt-get -y update && apt-get install -y vim  && apt-get install -y git

COPY run_ruby.sh /ruby/examples/run_ruby.sh
RUN chmod 755 /ruby/examples/run_ruby.sh
WORKDIR /ruby/examples

# allow interactive bash inside docker container
CMD ./run_ruby.sh $API_KEY $FILENAME $ALT_URL 

VOLUME ["/source"]