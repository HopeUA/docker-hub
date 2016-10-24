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

    # Youtrack install
    wget https://download.jetbrains.com/hub/${HUB_VERSION}/hub-ring-bundle-${HUB_VERSION}.${HUB_BUILD}.zip && \

    mkdir -p ${HUB_INSTALL} && \
    unzip hub-ring-bundle-${HUB_VERSION}.${HUB_BUILD}.zip && \
    rm -rf hub-ring-bundle-${HUB_VERSION}.${HUB_BUILD}/internal/java && \
    mv hub-ring-bundle-${HUB_VERSION}.${HUB_BUILD} ${HUB_INSTALL} && \

    echo "/usr/lib/jvm/default-jvm/bin/java" >> "${HUB_INSTALL}/conf/hub.java.path" && \

    # Cleanup
    apk del build-dependencies && \
    rm "/tmp/"*

VOLUME /data

EXPOSE ${HUB_PORT}

ENTRYPOINT "${HUB_INSTALL}/bin/hub.sh"
CMD ["run", "--no-browser"]
