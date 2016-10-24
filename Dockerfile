FROM hope/java:8

MAINTAINER Sergey Sadovoi <sergey@hope.ua>

ENV \
    # https://www.jetbrains.com/hub/download/#section=linux-version
    HUB_VERSION=2.5 \
    HUB_BUILD=399 \
    HUB_PORT=8080 \
    HUB_INSTALL=/usr/local/hub
    HUB_URL=http://localhost

RUN \
    apk add --no-cache --virtual=build-dependencies wget ca-certificates && \
    cd "/tmp" && \

    # Install
    wget https://download.jetbrains.com/hub/${HUB_VERSION}/hub-ring-bundle-${HUB_VERSION}.${HUB_BUILD}.zip && \

    unzip hub-ring-bundle-${HUB_VERSION}.${HUB_BUILD}.zip && \
    rm -rf hub-ring-bundle-${HUB_VERSION}.${HUB_BUILD}/internal/java && \
    mv hub-ring-bundle-${HUB_VERSION}.${HUB_BUILD} ${HUB_INSTALL} && \

    # Configure
    echo "/usr/lib/jvm/default-jvm/bin/java" > "${HUB_INSTALL}/conf/hub.java.path" && \

    ${HUB_INSTALL}/bin/hub.sh configure \
        --backups-dir=/data/backups \
        --temp-dir=/data/temp \
        --data-dir=/data/app \
        --logs-dir=/data/logs \
        --listen-port=${HUB_PORT} \
        --base-url=${HUB_URL} && \

    # Cleanup
    apk del build-dependencies && \
    rm "/tmp/"*

VOLUME /data

EXPOSE ${HUB_PORT}

ENTRYPOINT ["/usr/local/hub/bin/hub.sh"]
CMD ["run", "--no-browser"]
