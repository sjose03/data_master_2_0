#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE USER hue WITH PASSWORD 'hue';
	CREATE USER hive WITH PASSWORD '1234';
	CREATE USER superset WITH PASSWORD 'superset';
	CREATE USER apicurioregistry WITH PASSWORD 'password';
	CREATE DATABASE metastore;
	CREATE DATABASE superset;
	CREATE DATABASE apicurioregistry;
	CREATE DATABASE hue;
	GRANT ALL PRIVILEGES ON DATABASE hue TO hue;
	GRANT ALL PRIVILEGES ON DATABASE metastore TO hive;
	GRANT ALL PRIVILEGES ON DATABASE apicurioregistry TO apicurioregistry;
	GRANT ALL PRIVILEGES ON DATABASE superset TO superset;
EOSQL