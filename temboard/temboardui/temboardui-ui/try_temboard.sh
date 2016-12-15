#!/bin/bash

while [[ true ]]; do
    temboard
    echo "temboard failed, probably database is not ready yet"
    echo "sleeping 2 seconds..."
    echo ""
    sleep 2;
done
