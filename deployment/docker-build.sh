#!/usr/bin/env bash

lein clean; lein uberjar
docker build -t mastodonc/kixi.kafka.s3.backup -f deployment/Dockerfile .
docker tag mastodonc/kixi.kafka.s3.backup mastodonc/kixi.kafka.s3.backup:git-$(git rev-parse HEAD | cut -c1-7)
docker push mastodonc/kixi.kafka.s3.backup:git-$(git rev-parse HEAD | cut -c1-7)
echo "tag pushed:" $(git rev-parse HEAD | cut -c1-7)
