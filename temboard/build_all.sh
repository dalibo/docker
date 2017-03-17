#!/bin/bash

set -eo pipefail

dir="$(dirname $0)"

echo "######################"
echo "#                    #"
echo "#  Build script for  #"
echo "#    temboard        #"
echo "#                    #"
echo "######################"


function rmi {
    image="$1"
    if [[ -z $image ]]; then
        echo "Error!"
        exit 1
    fi

    nb=$(docker images $image |wc -l)
    if [[ $nb -eq 2 ]]; then
        docker rmi -f $image
    fi
}

echo ""
echo "==========================="
echo "Minor versions to be built:"
echo ""
echo "temboard:latest"
echo "temboard-agent-XY:latest"
echo "==========================="
echo ""
echo "Build images ? [y/N]"
read cont

if [ "$cont" != "y" -a "$cont" != "Y" ]; then
    echo "Stopping now"
    exit 1
fi

echo "############################"
echo "##                         #"
echo "##        temboard         #"
echo "##                         #"
echo "############################"
echo ""
echo "Removing old images..."
make -C temboard clean
echo "Building temboard:latest in $BASEDIR..."
make -C temboard build

echo ""
echo "############################"
echo "##                         #"
echo "##      temboard-pg-XY     #"
echo "##                         #"
echo "############################"
echo ""

BASEDIR="$dir/temboard-agent"
for version in $(ls "$BASEDIR" | egrep '[0-9]+\.[0-9]+'); do
    echo "Version $version"
    echo "================"
    echo ""
    echo "Removing old images... "

    v=$(echo "$version" | sed 's/\.//')
    smallver=$(echo $version |sed 's/\.//')
    CURDIR="$BASEDIR/$version"

    rmi "dalibo/temboard-agent-$smallver:latest"

    echo "Building temboard-agent-$smallver:latest..."
    docker build -q --no-cache -t dalibo/temboard-agent-$smallver:latest $CURDIR
    echo ""
done

echo "Done!"
echo ""
echo ""
