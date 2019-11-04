#### Run the lintr

Modify `.rubocop_todo.yml` as you fix issues.
Generate a new config file with `rubocop --auto-gen-config` as needed.

```
docker run -it -v $(pwd):/source --entrypoint bash ruby:2.6-slim-stretch
apt-get update
apt-get install -y gcc make

gem install rubocop
rubocop

```

#### Run tests locally

```
docker run -it -v $(pwd):/source --entrypoint bash ruby:2.6-slim-stretch
apt-get update
apt-get install -y gcc make

gem install rspec
bundle install
rspec tests

```

#### Run a single example

```
docker run -it -v $(pwd):/source --entrypoint bash ruby:2.6-slim-stretch

bundle install
cd examples

ruby ping.rb ${API_KEY}

```


#### Run all examples

```
docker run -it -v $(pwd):/source --entrypoint bash ruby:2.6-slim-stretch

bundle install
cd examples

for example in $(ls *.rb); do ruby ${example} ${API_KEY}; done

```

#### Build the gem

```
gem build rosette_api.gemspec
```

#### Install the gem

```
gem install rosette_api-*.gem
```
