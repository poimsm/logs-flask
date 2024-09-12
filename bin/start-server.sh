#!/bin/bash
source ./bin/check_env_mode.sh "$1"
source ./bin/commands.sh

CMD_PREFIX=$(detect_os)
DOCKER_COMPOSE=$(get_docker_compose)

${CMD_PREFIX} ${DOCKER_COMPOSE} -f docker-compose.$1.yml up -d
echo 'Server up'