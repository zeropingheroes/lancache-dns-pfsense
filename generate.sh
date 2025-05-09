#!/bin/bash

# Exit if there is an error
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# If there is an .env file use it
# to set the variables
if [ -f $SCRIPT_DIR/.env ]; then
    source $SCRIPT_DIR/.env
fi

# Check all required variables are set
: "${LANCACHE_IP:?must be set}"

# Read comma-separated list of IPs into array
IFS=',' read -ra IP_ARRAY <<< "$LANCACHE_IP"

# If no output file specified, set a default
: "${OUTPUT_FILE:=unbound-lancache.conf}"

echo "Getting domains from uklans/cache-domains"
rm -rf cache-domains
git clone git@github.com:uklans/cache-domains.git --depth 1

# Set the upstreams we want to create unbound configuration for
declare -a SERVICES=("blizzard" "origin" "riot" "steam" "windowsupdates")

echo "Generating config file"
echo "server:" > "$OUTPUT_FILE"

# Loop through each upstream file in turn
for SERVICE in "${SERVICES[@]}"
do
    echo >> $OUTPUT_FILE
    echo "    # $SERVICE domains" >> $OUTPUT_FILE

    # Read the upstream file line by line
    while read -r LINE || [ -n "$LINE" ];
    do
        # Skip line if it is a comment
        if [[ ${LINE:0:1} == '#' ]]; then
            continue
        fi

        # Check if hostname is a wildcard
        if [[ $LINE == *"*"* ]]; then

            # Remove the asterix and the dot from the start of the hostname
            LINE=${LINE/#\*./}

            # Add a wildcard config line
            echo "    local-zone: \"${LINE}.\" redirect" >> $OUTPUT_FILE
        fi

        # Create an A record for each IP
        for IP in "${IP_ARRAY[@]}"
        do
            echo "local-data: \"${LINE}. A $IP\"" >> $OUTPUT_FILE
        done

    done < cache-domains/$SERVICE.txt

done

echo "Unbound configuration file written to"
echo $OUTPUT_FILE
