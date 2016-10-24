FROM hope/java:8

MAINTAINER Sergey Sadovoi <sergey@hope.ua>

ENV \
    # https://www.jetbrains.com/hub/download/#section=linux-version
    HUB_VERSION=2.5 \
    HUB_BUILD=399 \
    HUB_PORT=8080 \
    HUB_INSTALL=/usr/local/hub

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

    BUNDLE_PROPS=${HUB_INSTALL}/conf/internal/bundle.properties && \
    mkdir -p ${HUB_INSTALL}/conf/internal && \
    echo "backups-dir=/data/backups" >> "${BUNDLE_PROPS}" && \
    echo "temp-dir=/data/temp" >> "${BUNDLE_PROPS}" && \
    echo "data-dir=/data/app" >> "${BUNDLE_PROPS}" && \
    echo "logs-dir=/data/logs" >> "${BUNDLE_PROPS}" && \
    echo "listen-port=${HUB_PORT}" >> "${BUNDLE_PROPS}" && \

    # Cleanup
    apk del build-dependencies && \
    rm "/tmp/"*

VOLUME /data

EXPOSE ${HUB_PORT}

ENTRYPOINT ["/usr/local/hub/bin/hub.sh"]
CMD ["run", "--no-browser"]
