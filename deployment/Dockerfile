FROM java:8-jre-alpine
MAINTAINER Jason Bell <jason.bell@mastodonc.com>

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.11.0.1/s6-overlay-amd64.tar.gz /tmp/

RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /
RUN apk add --update libgcc libstdc++ bash bash-doc bash-completion

ADD scripts/run-stream.sh /opt/run-stream.sh
ADD target/uberjar/kafka-streams-backup.jar /opt/kafka-streams-backup.jar


ENTRYPOINT ["/init"]

CMD ["/opt/run-stream.sh"]
