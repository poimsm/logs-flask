#!/bin/bash

source ./bin/check_env_mode.sh "$1"
source ./bin/commands.sh

CMD_PREFIX=$(detect_os)
DOCKER_COMPOSE=$(get_docker_compose)

# Analizar argumentos adicionales para encontrar un servicio específico
specific_service=""
for arg in "$@"; do
  case $arg in
    --service=*)
      specific_service="${arg#*=}"
      break
      ;;
  esac
done

if [[ -n $specific_service ]]; then
  # Si se ha especificado un servicio, detener solo ese servicio
  echo "Stopping only the specified service: $specific_service"
  ${CMD_PREFIX} ${DOCKER_COMPOSE} -f docker-compose.$1.yml stop "$specific_service"
else
  # Si no se especifica servicio, detener todos los servicios
  echo "Stopping all services"
  ${CMD_PREFIX} ${DOCKER_COMPOSE} -f docker-compose.$1.yml stop
fi

echo 'Server stopped'