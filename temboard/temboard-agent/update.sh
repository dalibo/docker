#!/bin/bash

set -eo pipefail

dir="$(dirname $0)"
template="$dir/Dockerfile.template"
sh="setup_temboard-agent.sh"
conf="temboard-agent.conf"


echo "########################"
echo "#                      #"
echo "# Updating Dockerfiles #"
echo "# for temboard-agent   #"
echo "#                      #"
echo "########################"
for version in $(ls "$dir"| egrep '[0-9]+\.[0-9]+'); do
    echo "Setting up temboard-agent-$version..."
    echo ""

    v="$dir/$version"
    smallver=$(echo $version |sed 's/\.//')
    docker="$v/Dockerfile"

    # clean everything in the X.Y directory
    rm -f "$v/*"

    # create new Dockerfile
    sed "s/%%PG_VER%%/$version/g" "$template" > "$docker"
    sed -i "s/%%PG_SMALLVER%%/$smallver/" "$docker"

    # do the agent configuration
    sed "s/%%PG_SMALLVER%%/$smallver/" "${conf}.template" > "$v/$conf"

    # add the needed resources
    cp "$dir/$sh" "$v/$sh"
    cp "$dir/users" "$v/"
    cp "$dir/supervisord.conf" "$v/"
done
echo "Done"
echo ""
