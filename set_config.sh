#!/usr/bin/env bash
# This script setups .env configuration.

helpFunction()
{
    echo ""
    echo "Usage: $0 -U DB_USERNAME -W DB_PASSWORD -H DB_HOSTNAME -P DB_PORT -N DB_NAME"
    echo -e "\t-DB_USERNAME Connect to the database as the user DB_USERNAME"
    echo -e "\t-DB_PASSWORD The password for user DB_USERNAME to connect to the database"
    echo -e "\t-DB_HOSTNAME Specifies the host name of the machine on which the server is running"
    echo -e "\t-DB_PORT Specifies the TCP port or the local Unix-domain socket file extension on which the server is listening for connections"
    echo -e "\t-DB_NAME Specifies the name of the database to connect to"
    exit 1 # Exit script after printing help
}

set_variables()
{
    sudo apt-get -qqy update
    sudo apt-get -yy install pwgen
    COOKIE_SECRET=$(pwgen -1s 32)
    SECRET_KEY=$(pwgen -1s 32)

    while getopts "U:W:H:P:N:" opt
    do
        case "$opt" in
            U ) DB_USERNAME="$OPTARG" ;;
            W ) DB_PASSWORD="$OPTARG" ;;
            H ) DB_HOSTNAME="$OPTARG" ;;
            P ) DB_PORT="$OPTARG" ;;
            N ) DB_NAME="$OPTARG" ;;
            ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
        esac
    done

    # Print helpFunction in case parameters are empty
    if [ -z "$DB_USERNAME" ] || [ -z "$DB_PASSWORD" ] || [ -z "$DB_HOSTNAME" ] || [ -z "$DB_PORT" ] || [ -z "$DB_NAME" ]
    then
        echo "Some or all of the parameters are empty";
        helpFunction
    fi
}

write_env_file()
{
    if [[ -e ./.env ]]; then
        rm ./.env
        touch ./.env
    fi

    POSTGRES_PASSWORD="$DB_PASSWORD"
    REDASH_DATABASE_URL="postgresql://${DB_USERNAME}:${POSTGRES_PASSWORD}@${DB_HOSTNAME}:${DB_PORT}/${DB_NAME}"

    echo "POSTGRES_PASSWORD=$POSTGRES_PASSWORD" >> ./.env
    echo "REDASH_COOKIE_SECRET=$COOKIE_SECRET" >> ./.env
    echo "REDASH_SECRET_KEY=$SECRET_KEY" >> ./.env
    echo "REDASH_DATABASE_URL=$REDASH_DATABASE_URL" >> ./.env
}

set_variables "$@"
write_env_file
