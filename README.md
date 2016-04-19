---
# Ruby Binding for Rosette API
---

### Summary
This repository provides a Ruby binding and examples for each of the supported Rosette API endpoints.

### Basic Usage

Install Ruby if you haven't already.  Instructions can be found [here](https://www.ruby-lang.org/en/documentation/installation/).

Once Ruby is installed simply run the example as: `ruby examplefile.rb your_api_key` to see the results.

### Docker

A Dockerfile may be built (examples/docker) to run the examples and unit tests

1. `sudo docker build --rm -t ruby-docker .`
1. `cd ruby_root_direcory`
1. `sudo docker run --rm -e API_KEY=valid_api_key -v `pwd`:/source ruby-docker`

### Testing

Unit tests are based on RSpec.

1. Launch the docker image interactively, `sudo docker run --rm -it -e API_KEY=valid_api_key -v `pwd`:/source ruby-docker /bin/bash`
1. `cd tests`
1. `rspec tests.rb`

### Gem Package

Coming soon


