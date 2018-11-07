#!/bin/bash

set -eo pipefail

dir="$(dirname $0)"
template="$dir/Dockerfile.template"
sh="setup_powa-archivist.sh"
sql="install_all.sql"

echo "########################"
echo "#                      #"
echo "# Updating Dockerfiles #"
echo "# for powa-archivist   #"
echo "#                      #"
echo "########################"
for version in $(ls "$dir"| egrep '[0-9]+(\.[0-9]+)?'); do
    echo "Setting up powa-archivist-$version..."
    echo ""

    v="$dir/$version"
    docker="$v/Dockerfile"

    # clean everything in the X.Y directory
    rm -f "$v/*"

    # create new Dockerfile
    sed "s/%%PG_VER%%/$version/g" "$template" > "$docker"

    # add the needed resources
    cp "$dir/$sh" "$v/$sh"
    cp "$dir/$sql" "$v/$sql"
done
echo "Done"
echo ""
