Ruby Examples
============
Each example class can be run independently.

Each example file demonstrates one of the capabilities of the Rosette Platform.

A note on prerequisites. Rosette API only suports TLS 1.2 so ensure your toolchain also supports it.

## Running the example
You can run your desired `_endpoint_.rb` file to see it in action.

`ruby _endpoint_.rb api_key(required) alternate_url(optional)`

For example, run `ruby categories.js <your_key>` if you want to see the categories
functionality demonstrated.

All files require you to input your Rosette API User Key after `--key` to run.
For example: `ruby ping.js 1234567890`

To run all of the examples:
`find -maxdepth 1 -name *.rb -exec ruby {} api_key alternate_url`

Each example, when run, prints its output to the console.

## Docker ##
A Docker image for running the examples against the compiled source library is available on Docker Hub.

Command: `docker run -e API_KEY=api-key -v "<binding root directory>:/source" rosetteapi/docker-ruby`

Additional environment settings:
`-e ALT_URL=<alternative URL>`
`-e FILENAME=<single filename>`
