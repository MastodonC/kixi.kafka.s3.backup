#!/usr/bin/env bash

MASTER=$1
DOCKERID=$2
TAG=$3
NUMBER=$4

sed -e "s/@@TAG@@/$TAG/" -e "s/@@NUMBER@@/$NUMBER/" -e "s%@@AWS_ACCESS_KEY_ID@@%${AWS_ACCESS_KEY_ID}%" -e "s%@@AWS_SECRET_KEY@@%${AWS_SECRET_KEY}%" -e "s/@@S3_BUCKET@@/${S3_BUCKET}/" -e "s/@@ZK_CONNECT@@/${ZK_CONNECT}/" -e "s/@@KAFKA_TOPIC@@/${KAFKA_TOPIC}/" -e "s/@@KAFKA_CONSUMER_GROUP@@/${KAFKA_CONSUMER_GROUP}/" -e "s/@@DOCKERID@@/${DOCKERID}/"  kafkabackup-stream-config.json.template > kafkabackup-stream-config-$NUMBER.json


# we want curl to output something we can use to indicate success/failure

STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST http://$MASTER/marathon/v2/apps -H "Content-Type: application/json" --data-binary "@kafkabackup-stream-config-$NUMBER.json")
echo "HTTP code " $STATUS
if [ $STATUS == "201" ]
then exit 0
else exit 1
fi
