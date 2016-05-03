#!/bin/bash

ping_url="https://api.rosette.com/rest/v1"
retcode=0
errors=( "Exception" "processingFailure" )

#------------ Start Functions --------------------------

#Gets called when the user doesn't provide any args
function HELP {
    echo -e "\nusage: source_file.rb API_KEY [ALT_URL]"
    echo "  API_KEY      - Rosette API key (required)"
    echo "  FILENAME     - Ruby source file (optional)"
    echo "  ALT_URL      - Alternate service URL (optional)"
    echo "  GIT_USERNAME - Git username where you would like to push regenerated gh-pages (optional)"
    echo "  VERSION      - Build version (optional)"
    exit 1
}

#Checks if Rosette API key is valid
function checkAPI {
    match=$(curl "${ping_url}/ping" -H "X-RosetteAPI-Key: ${API_KEY}" |  grep -o "forbidden")
    if [ ! -z $match ]; then
        echo -e "\nInvalid Rosette API Key"
        exit 1
    fi  
}

#Checks for valid url
function validateURL() {
    match=$(curl "${ping_url}/ping" -H "X-RosetteAPI-Key: ${API_KEY}" |  grep -o "Rosette API")
    if [ "${match}" = "" ]; then
        echo -e "\n${ping_url} server not responding\n"
        exit 1
    fi  
}

function runExample() {
    echo -e "\n---------- ${1} start -------------"
    result=""
    if [ -z ${ALT_URL} ]; then
        result="$(ruby ${1} ${API_KEY} 2>&1 )"
    else
        result="$(ruby ${1} ${API_KEY} ${ALT_URL} 2>&1 )"
    fi
    echo "${result}"
    echo -e "\n---------- ${1} end -------------"
    for err in "${errors[@]}"; do 
        if [[ ${result} == *"${err}"* ]]; then
            retcode=1
        fi
    done
}

#------------ End Functions ----------------------------

#Gets API_KEY, FILENAME and ALT_URL if present
while getopts ":API_KEY:FILENAME:ALT_URL:GIT_USERNAME:VERSION" arg; do
    case "${arg}" in
        API_KEY)
            API_KEY=${OPTARG}
            usage
            ;;
        ALT_URL)
            ALT_URL=${OPTARG}
            usage
            ;;
        FILENAME)
            FILENAME=${OPTARG}
            usage
            ;;
        GIT_USERNAME)
            GIT_USERNAME=${OPTARG}
            usage
            ;;
        VERSION)
            VERSION={OPTARG}
            usage
            ;;
    esac
done

validateURL

#Copy the mounted content in /source to current WORKDIR
cp -r -n /source/. .

#Build rosette_api gem
gem build rosette_api.gemspec
gem install ./rosette_api-1.0.2.gem

#Run the examples
if [ ! -z ${API_KEY} ]; then
    checkAPI
    cd tests
    rspec tests_spec.rb
    cd ../examples
    if [ ! -z ${FILENAME} ]; then
        runExample ${FILENAME}
    else
        for file in *.rb; do
            runExample ${file}
        done
    fi
else 
    HELP
fi

#Generate gh-pages and push them to git account (if git username is provided)
if [ ! -z ${GIT_USERNAME} ] && [ ! -z ${VERSION} ]; then
    #clone ruby git repo
    cd /
    git clone git@github.com:${GIT_USERNAME}/ruby.git
    cd ruby
    git checkout origin/gh-pages -b gh-pages
    git branch -d develop
    #generate gh-pages and set ouput dir to git repo (gh-pages branch)
    cd /ruby-dev/lib
    rdoc -o /doc
    cp -r -n /doc/. /ruby
    cd /ruby
    git add .
    git commit -a -m "publish ruby apidocs ${VERSION}"
    git push
fi

exit ${retcode}
