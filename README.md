# Setup script for Redash with Docker on Ubuntu 18.04.

This is a modified version of the reference setup for Redash on a single Ubuntu 18.04 server, which uses Docker and Docker Compose for deployment and management.

The reference setup is the setup Redash use for their official images (for AWS & Google Cloud) and can be used as reference if you want to manually setup Redash in a different environment (different OS or different deployment location).

* `set_config.sh` is the script to configure metadata storage connection into local `.env`.
* `setup_external_metadb.sh` is the script that installs everything and creates the directories. The Redash server will be connected into the external server following configurations in local `.env`.
* `setup.sh` is the script that installs everything and creates the directories. using this script, your Redash sever will store metadata in internal PostgresSQL.
* `docker-compose.yml` is the Docker Compose setup we use.
* `packer.json` is Packer configuration Redash use to create the Cloud images. Modification has not been applied for now.

## Getting started

### Metadata storage configurations

```
chmod +x set_config.sh
./set_config.sh -U DB_USERNAME -W DB_PASSWORD -H DB_HOSTNAME -P DB_PORT -N DB_NAME
```

replace placeholders(all capital) and pass the parameters as required. *It is highly recommended to save .env file after the configuration, you do not want to lose COOKIE_SECRET and SECRET_KEY.*

### Redash setup

```
chmod +x setup_external_metadb.sh
./setup_external_metadb.sh
```

### Schedule redis backup - not mandatory
For production setups, this step is recommended.

```
chmod +x data/schedule_redis_backup.sh
./data/schedule_redis_backup.sh -C CRON_EXPRESSION
```

A CRON expression is a string that represents a set of times, as a schedule to execute the routine.
[Check this out](https://en.wikipedia.org/wiki/Cron#CRON_expression)

## FAQ

### Can I use `setup.sh` in production?

For small scale deployments -- yes. But for larger deployments we recommend at least splitting the database (and probably Redis) into its own server (preferably a managed service like RDS) and setting up at least 2 servers for Redash for redundancy. You will also need to tweak the number of workers based on your usage patterns.

### How do I upgrade to newer versions of Redash?

See [Upgrade Guide](https://redash.io/help/open-source/admin-guide/how-to-upgrade).

### How do I use `setup.sh` on a different operating system?

You will need to update the `install_docker` function and maybe other functions as well.
