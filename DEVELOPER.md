#### Run the lintr

Modify `.rubocop_todo.yml` as you fix issues.
Generate a new config file with `rubocop --auto-gen-config` as needed.

```
docker run -it -v $(pwd):/source --entrypoint bash ruby:3.4-slim
apt-get update
apt-get install -y gcc make

gem install rubocop
cd /source
rubocop

```

#### Check dependencies for CVEs

This uses `bundler-audit`, which checks your `Gemfile.lock` against the RubySec advisory DB.

```
docker run -it -v $(pwd):/source --entrypoint bash ruby:3.4-slim
apt-get update
apt-get install -y gcc make git ca-certificates libyaml-dev

cd /source
bundle install

gem install bundler-audit
bundle audit update
bundle audit check --verbose

```



#### Run tests locally

```
docker run -it -v $(pwd):/source --entrypoint bash ruby:3.4-slim
apt-get update
apt-get install -y gcc make libyaml-dev

gem install rspec
cd /source
bundle install
rspec tests

```

#### Run a single example

```
docker run -it -v $(pwd):/source --entrypoint bash ruby:3.4-slim
apt-get update
apt-get install -y gcc make libyaml-dev

cd /source
bundle install
gem build rosette_api.gemspec
gem install rosette_api-*.gem
cd examples

ruby ping.rb ${API_KEY}

```


#### Run all examples

```
docker run -it -v $(pwd):/source --entrypoint bash ruby:3.4-slim
apt-get update
apt-get install -y gcc make libyaml-dev

cd /source
bundle install
gem build rosette_api.gemspec
gem install rosette_api-*.gem
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
