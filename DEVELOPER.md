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
rspec tests

```
