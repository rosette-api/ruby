## Endpoint Examples

These examples are scripts that can be run independently to demonstrate the Rosette API functionality.

Each example file demonstrates one of the capabilities of the Rosette Platform. Each example, when run, prints its output to the console.

Here are some methods for running the examples.  Each example will also accept an optional parameter for
overriding the default URL.  To use, place the url parameter after the key parameter.

A note on prerequisites. Rosette API only suports TLS 1.2 so ensure your toolchain also supports it.

#### Docker/Latest Version From RubyGems
```
git clone git@github.com:rosette-api/ruby.git
cd ruby
docker run -it -v $(pwd):/source --entrypoint bash ruby:3.3-slim

gem install rosette_api

cd /source/examples
ruby ping.rb $API_KEY
```

#### Docker/Latest Source
```
git clone git@github.com:rosette-api/ruby.git
cd ruby
docker run -it -v $(pwd):/source --entrypoint bash ruby:3.3-slim

cd /source
gem build rosette_api.gemspec
gem install rosette_api*.gem

cd examples
ruby ping.rb $API_KEY
```
