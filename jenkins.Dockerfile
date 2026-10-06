FROM ruby:4-slim-trixie
LABEL source="https://github.com/rosette-api/ruby/blob/master/jenkins.Dockerfile"

RUN apt-get -y update && \
    apt-get install -y \
      build-essential \
      curl \
      git

WORKDIR /ruby
COPY docker-entrypoint.sh docker-entrypoint.sh
RUN chmod 0755 docker-entrypoint.sh

VOLUME ["/source"]

ENTRYPOINT ["./docker-entrypoint.sh"]
