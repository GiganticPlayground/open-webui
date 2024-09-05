#!/bin/bash

# if command line includes any arguments, pass them all to the docker compose command
if [ $# -gt 0 ]; then
    docker compose -f docker-compose-custom1.yml build "$@"
    exit
fi

# else run the default command
docker compose -f docker-compose-custom1.yml build