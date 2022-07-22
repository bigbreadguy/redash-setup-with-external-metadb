#!/usr/bin/env bash

helpFunction()
{
    echo ""
    echo "Usage: $0 -C CRON_EXPRESSION"
    echo -e "\t-C Specifies routine schedule for the operation"
    exit 1 # Exit script after printing help
}

setSchedule()
{
    while getopts "C:" opt
    do
        case "$opt" in
            C ) CRON_EXPRESSION="$OPTARG" ;;
            ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
        esac
    done
  
    (crontab -l 2>/dev/null; echo "$CRON_EXPRESSION sudo docker exec -it redash_redis_1 redis-cli -c 'BGSAVE'") | crontab -
}

setSchedule "$@"
