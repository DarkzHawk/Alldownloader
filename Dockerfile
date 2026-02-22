# syntax=docker/dockerfile:1.7

FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG HITOMI_VERSION=v4.2
ARG HITOMI_ASSET=hitomi_downloader_GUI.zip

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    WINEARCH=win64 \
    WINEPREFIX=/config/wine \
    WINEDEBUG=-all \
    WINEDLLOVERRIDES=mscoree,mshtml= \
    HITOMI_HOME=/opt/hitomi \
    DISPLAY=:99

RUN dpkg --add-architecture i386 \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    ca-certificates \
    cabextract \
    curl \
    unzip \
    winbind \
    xauth \
    xvfb \
    wine64 \
    wine32 \
    fonts-nanum \
    fonts-noto-cjk \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/hitomi /config /downloads /work

RUN curl -fL "https://github.com/KurtBestor/Hitomi-Downloader/releases/download/${HITOMI_VERSION}/${HITOMI_ASSET}" -o /tmp/hitomi.zip \
 && unzip -q /tmp/hitomi.zip -d /opt/hitomi \
 && rm -f /tmp/hitomi.zip

COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

VOLUME ["/config", "/downloads", "/work"]
WORKDIR /work

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
