#!/bin/bash

set -eo pipefail

dir="$(dirname $0)"

echo "######################"
echo "#                    #"
echo "#  Build script for  #"
echo "#    powa            #"
echo "#                    #"
echo "######################"


# get a X.Y.Z information from the latest release name, which should be
# "version X.Y.Z". The releanse name can be easily edited, so this should be
# more reliable than using the release tags.
ARCHIVIST="$(wget -O- https://api.github.com/repos/dalibo/powa-archivist/releases/latest | jq -r '.name' | sed 's/version //')"
WEB="$(wget -O- https://api.github.com/repos/dalibo/powa-web/releases/latest | jq -r '.name' | sed 's/version //')"

function rmi {
    image="$1"
    if [[ -z $image ]]; then
        echo "Error!"
        exit 1
    fi

    nb=$(docker images $image |wc -l)
    if [[ $nb -eq 2 ]]; then
        docker rmi --force $image
    fi
}

echo ""
echo "==========================="
echo "Minor versions to be built:"
echo ""
echo "powa-archivist: $ARCHIVIST"
echo "powa-web: $WEB"
echo "====================="
echo ""
echo "Build images ? [y/N]"
read cont

if [ "$cont" != "y" -a "$cont" != "Y" ]; then
    echo "Stopping now"
    exit 1
fi

echo "############################"
echo "##                         #"
echo "##     powa-archivist      #"
echo "##                         #"
echo "############################"
echo ""

BASEDIR="$dir/powa-archivist"
for version in $(ls "$BASEDIR" | egrep '[0-9]+\.[0-9]+'); do
    echo "Version $version"
    echo "================"
    echo ""
    echo "Removing old images... "

    v=$(echo "$version" | sed 's/\.//')
    CURDIR="$BASEDIR/$version"

    rmi "dalibo/powa-archivist-$version:latest"
    rmi "dalibo/powa-archivist-$version:$ARCHIVIST"

    echo "Building powa-archivist tag $ARCHIVIST..."
    docker build -q --no-cache -t dalibo/powa-archivist-$v:$ARCHIVIST $CURDIR
    echo "Updating powa-archivist:latest..."
    docker build -q -t dalibo/powa-archivist-$v:latest $CURDIR
done

echo ""
echo "############################"
echo "##                         #"
echo "##        powa-web         #"
echo "##                         #"
echo "############################"
echo ""
echo "Removing old images..."

BASEDIR="$dir/powa-web"
rmi "dalibo/powa-web:latest"
rmi "dalibo/powa-web:$WEB"

echo "Building powa-web tag $WEB..."
docker build -q --no-cache -t dalibo/powa-web:$WEB $BASEDIR
echo "Updating powa-web:latest..."
docker build -q -t dalibo/powa-web:latest $BASEDIR

echo ""
echo "Done!"
echo ""
echo ""
