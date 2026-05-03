# syntax=docker/dockerfile:1

FROM debian:bookworm-slim AS airptpd-builder

ARG TARGETARCH

ENV LANG=C.UTF-8

RUN echo TARGETARCH=$TARGETARCH

# Create our Debian package sources list - this is copied from Music Assistant Dockerfile.base
# but, there is an existing source.list config in bookworm-slim, so not sure why this is necessary
RUN echo "deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware" > /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list

# Install build dependencies for airptpd
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    libtool \
    autotools-dev \
    autoconf \
    automake \
    autopoint \
    pkgconf \
    gettext \
    libevent-dev

COPY . .

RUN set -x \
    && autoreconf -vi \
    && ./configure --enable-daemon \
    && make \
    && mkdir -p release \
    && cp -v daemon/airptpd release/airptpd-$TARGETARCH \
    && chmod +x release/airptpd-$TARGETARCH \
    && file release/airptpd-$TARGETARCH \
    && ldd release/airptpd-$TARGETARCH

# FROM scratch
# ARG TARGETARCH
# COPY --from=airptpd-builder release/airptpd-$TARGETARCH /
# ENTRYPOINT ["/airptpd-$TARGETARCH --testrun"]
