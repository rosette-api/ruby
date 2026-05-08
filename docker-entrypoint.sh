#!/usr/bin/env bash

retcode=0
failed_examples=()
service_url="https://analytics.babelstreet.com/rest/v1"
errors=( "Exception" "processingFailure" "badRequest" "ParseError" "ValueError" "SyntaxError" "AttributeError" "ImportError" "Timeout")

usage() {
    echo -e "\nusage: $0 --key API_KEY [--url ALT_URL]"
    echo "  API_KEY       - Babel Street API key (required)"
    echo "  FILENAME      - source file (optional)"
    echo "  ALT_URL       - Alternate service URL (optional)"
    echo "Compiles and runs the source file(s) using the local development source."
    exit 1
}

if [ -n "${ALT_URL}" ]; then
    service_url="${ALT_URL}"
fi

cleanURL() {
    # strip the trailing slash off of the alt_url if necessary
    if [ ! -z "${ALT_URL}" ]; then
        case ${ALT_URL} in
            */) ALT_URL=${ALT_URL::-1}
                echo "Slash detected"
                ;;
        esac
        service_url=${ALT_URL}
    fi
}

checkAPIKey() {
  output_file=check_key_out.log
  http_status_code=$(curl -s -o "${output_file}" -w "%{http_code}" -H "X-BabelStreetAPI-Key: ${API_KEY}" "${service_url}/ping")
  if [ "${http_status_code}" = "403" ]; then
      echo -e "\nInvalid Babel Street Analytics API key.  Output is:\n"
      cat "${output_file}"
      exit 1
  fi
}

validateURL() {
    output_file=validate_url_out.log
    http_status_code=$(curl -s -o "${output_file}" -w "%{http_code}" -H "X-BabelStreetAPI-Key: ${API_KEY}" "${service_url}/ping")
    if [ "${http_status_code}" != "200" ]; then
        echo -e "\n${service_url} server not responding.  Output is:\n"
        cat "${output_file}"
        exit 1
    fi
}

runExample() {
    echo -e "\n---------- ${1} start -------------"
    result=""
    if [ -z "${ALT_URL}" ]; then
        result="$(ruby ${1} ${API_KEY} 2>&1 )"
    else
        result="$(ruby ${1} ${API_KEY} ${ALT_URL} 2>&1 )"
    fi
    echo "${result}"
    echo -e "\n---------- ${1} end -------------"

    local has_failed=false
    for err in "${errors[@]}"; do
        if [[ ${result} == *"${err}"* ]]; then
            retcode=1
            has_failed=true
            break
        fi
    done

    if [ "${has_failed}" = true ]; then
        failed_examples+=("${1}")
    fi
}

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --key)
            API_KEY="$2"
            shift 2
            ;;
        --url)
            ALT_URL="$2"
            shift 2
            ;;
        --filename)
            FILENAME="$2"
            shift 2
            ;;
        *)
            usage
            ;;
    esac
done

cp -r -n /source/. .

cleanURL

validateURL

# Build rosette_api gem
if ! gem build rosette_api.gemspec; then
    echo "Failed to build rosette_api gem build."
    exit 1
fi

if ! gem install ./rosette_api-*.gem; then
    echo "Failed to install rosette_api gem."
    exit 1
fi

echo -e "\nRunning tests..."
bundle install --quiet
cd tests
if ! rspec tests_spec.rb; then
    echo "rspec tests failed."
    exit 1
fi
cd ..

#Run the examples
if [ -n "${API_KEY}" ]; then
    checkAPIKey
    cd examples
    if [ -n "${FILENAME}" ]; then
        echo -e "\nRunning example against: ${service_url}\n"
        runExample "${FILENAME}"
    else
        echo -e "\nRunning examples against: ${service_url}\n"
        for file in *.rb; do
            runExample "${file}"
        done
    fi
    cd ..
else
    usage
fi

if [[ ${#failed_examples[@]} -gt 0 ]]; then
    echo -e "\n=============================================="
    echo "Failed Examples Summary:"
    for failed in "${failed_examples[@]}"; do
        echo "  - ${failed}"
    done
    echo "=============================================="
else
    if [ "${retcode}" -eq 0 ] && [ -n "${API_KEY}" ]; then
        echo -e "\n=============================================="
        echo "All examples completed successfully."
        echo "=============================================="
    fi
fi

exit "${retcode}"
