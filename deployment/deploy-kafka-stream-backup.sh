#!/usr/bin/env bash

MASTER=$1
TAG=$2
NUMBER=$3
S3_BUCKET=$4
KAFKA_TOPICS=measurements,tariffs
KAFKA_CONSUMER_GROUP=kixi.kafka.s3.backup

sed -e "s/@@TAG@@/$TAG/" -e "s/@@NUMBER@@/$NUMBER/" -e "s/@@S3_BUCKET@@/${S3_BUCKET}/" -e "s/@@KAFKA_TOPICS@@/${KAFKA_TOPICS}/" -e "s/@@KAFKA_CONSUMER_GROUP@@/${KAFKA_CONSUMER_GROUP}/" -e "s/@@DOCKERID@@/${DOCKERID}/"  kafkas3backup-stream-config.json.template > kafkabackup-stream-config-$NUMBER.json


# we want curl to output something we can use to indicate success/failure

STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST http://$MASTER/marathon/v2/apps -H "Content-Type: application/json" --data-binary "@kafkabackup-stream-config-$NUMBER.json")
echo "HTTP code " $STATUS
if [ $STATUS == "201" ]
then exit 0
else exit 1
fi
