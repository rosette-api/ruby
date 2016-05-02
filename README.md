[![Build Status](https://travis-ci.org/rosette-api/ruby.svg?branch=master)](https://travis-ci.org/rosette-api/ruby)

Ruby client binding for Rosette API
==================================
See the wiki for more information.

Installation
------------

`gem install rosette_api`

Basic Usage
-----------

See [examples](examples)

API Documentation
-----------------

See [documentation](http://rosette-api.github.io/ruby)

Testing
-----------------
Unit tests are based on RSpec.
1. Launch the docker image interactively, `sudo docker run --rm -it -e API_KEY=valid_api_key -v `pwd`:/source ruby-docker /bin/bash`
2. `cd tests`
3. `rspec tests_spec.rb`

Additional Information
----------------------

Visit [Rosette API site](https://developer.rosette.com)
