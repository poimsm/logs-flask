#!/bin/bash

# Esperar a que PostgreSQL esté disponible
until nc -z $DB_HOST $DB_PORT; do
  echo "Esperando a la base de datos..."
  sleep 1
done

# Crear las tablas directamente con Python
python -c "from app import app, db; app.app_context().push(); db.create_all()"

# Iniciar el servidor con Gunicorn
exec gunicorn --bind 0.0.0.0:5000 app:app
