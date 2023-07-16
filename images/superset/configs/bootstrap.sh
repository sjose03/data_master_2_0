#!/bin/bash
superset db upgrade
superset fab create-admin \
              --username admin \
              --firstname Superset \
              --lastname Admin \
              --email admin@superset.com \
              --password admin
echo "Setting up admin user"
# Create default roles and permissions
echo "Superset init"
superset init
superset run -h 0.0.0.0 -p ${SUPERSET_PORT}