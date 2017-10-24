[![Build Status](https://travis-ci.org/rosette-api/ruby.svg?branch=develop)](https://travis-ci.org/rosette-api/ruby)

# Ruby client binding for Rosette API #
See the wiki for more information.

## Installation ##

`gem install rosette_api`

If the version you are using is not [the latest from RubyGems](https://rubygems.org/gems/rosette_api),
please check for its [**compatibilty with api.rosette.com**](https://developer.rosette.com/features-and-functions?ruby).
If you have an on-premise version of Rosette API server, please contact support for
binding compatibility with your installation.

To check your installed version:

`gem list rosette_api`

## Docker ##
A Docker image for running the examples against the compiled source library is available on Docker Hub.

Command: `docker run -e API_KEY=api-key -v "<binding root directory>:/source" rosetteapi/docker-ruby`

Additional environment settings:
`-e ALT_URL=<alternative URL>`
`-e FILENAME=<single filename>`

## Basic Usage ##

See [examples](examples)

## API Documentation ##
See [documentation](http://rosette-api.github.io/ruby)

## Release Notes
See the [wiki](https://github.com/rosette-api/ruby/wiki/Release-Notes)

## Additional Information ##
Visit [Rosette API site](https://developer.rosette.com)
