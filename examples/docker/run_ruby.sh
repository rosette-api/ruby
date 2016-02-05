#!/bin/bash

#Gets called when the user doesn't provide any args
function HELP {
    echo -e "\nusage: source_file.rb API_KEY [ALT_URL]"
    echo "  API_KEY      - Rosette API key (required)"
    echo "  FILENAME     - Ruby source file (optional)"
    echo "  ALT_URL      - Alternate service URL (optional)"
    exit 1
}

#Gets API_KEY, FILENAME and ALT_URL if present
while getopts ":API_KEY:FILENAME:ALT_URL" arg; do
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
    esac
done

#Checks if Rosette API key is valid
function checkAPI {
    match=$(curl "https://api.rosette.com/rest/v1/ping" -H "user_key: ${API_KEY}" |  grep -o "forbidden")
    if [ ! -z $match ]; then
        echo -e "\nInvalid Rosette API Key"
        exit 1
    fi  
}


#Copy the mounted content in /source to current WORKDIR
cp /source/*.* .

#Run the examples
if [ ! -z ${API_KEY} ]; then
    checkAPI
    if [ ! -z ${FILENAME} ]; then
        if [ ! -z ${ALT_URL} ]; then
	    ruby ${FILENAME} ${API_KEY} ${ALT_URL} 
	else
	    ruby ${FILENAME} ${API_KEY} 
   	fi
    elif [ ! -z ${ALT_URL} ]; then
    	find -maxdepth 1  -name '*.rb' -print -exec ruby {} ${API_KEY} ${ALT_URL} \;
    else
	find -maxdepth 1  -name '*.rb' -print -exec ruby {} ${API_KEY} \;
    fi
else 
    HELP
fi
