#!/bin/bash

source ./bin/check_env_mode.sh "$1"
source ./bin/confirm_prod.sh "$1"

source ./bin/commands.sh

CMD_PREFIX=$(detect_os)
DOCKER_COMPOSE=$(get_docker_compose)

echo "Destroying server..."
${CMD_PREFIX} ${DOCKER_COMPOSE} -f docker-compose.$1.yml down -v --rmi all
