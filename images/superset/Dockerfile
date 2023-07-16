FROM apache/superset
# Switching to root to install the required packages
USER root
# Example: installing the MySQL driver to connect to the metadata database
# if you prefer Postgres, you may want to use `psycopg2-binary` instead
RUN pip install psycopg2-binary pyhive
# Example: installing a driver to connect to Redshift
# Find which driver you need based on the analytics database
# you want to connect to here:
# https://superset.apache.org/installation.html#database-dependencies

# database engine specific environment variables
# change the below if you prefer another database engine

# Switching back to using the `superset` user
ENV SUPERSET_PORT 8080
ENV SUPERSET_SECRET_KEY '5rfnXG/1rtIylIY0U2pKkMj82iEK5neT8ogjLV0w7Bi0E+B/Smg8Ko/q'

USER superset
COPY configs/ .
ENTRYPOINT ["/bin/bash", "bootstrap.sh"]
