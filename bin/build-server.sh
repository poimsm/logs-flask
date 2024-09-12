#!/bin/bash

# Cargar scripts de configuración
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
  # Si se ha especificado un servicio, construir solo ese servicio
  echo "Building only the specified service: $specific_service"
  ${CMD_PREFIX} ${DOCKER_COMPOSE} -f docker-compose.$1.yml build --no-cache "$specific_service"
  ${CMD_PREFIX} ${DOCKER_COMPOSE} -f docker-compose.$1.yml up -d "$specific_service"
else
  # Si no se especifica servicio, construir y levantar todos los servicios
  echo "Building and erecting all services"
  ${CMD_PREFIX} ${DOCKER_COMPOSE} -f docker-compose.$1.yml build --no-cache
  ${CMD_PREFIX} ${DOCKER_COMPOSE} -f docker-compose.$1.yml up -d
fi

echo 'Server up'
