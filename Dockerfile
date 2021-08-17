FROM alpine:3.14 AS builder

RUN \
  apk update && apk add --no-cache \
    abuild \
    alpine-sdk \
    binutils \
    cmake \
    gcc \
    g++ \
    libgcc \
    make \
    musl-dev \
    sudo

RUN \
  adduser -D packager && \
  addgroup packager abuild && \
  mkdir -p /var/cache/distfiles && \
  chmod a+w /var/cache/distfiles && \
  chgrp abuild /var/cache/distfiles && \
  chmod g+w /var/cache/distfiles && \
  echo "packager  ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  mkdir /packager && chown packager:abuild /packager

WORKDIR /packager
USER packager

ENV LDFLAGS="--static"
ENV MAKEFLAGS="-j4"

RUN abuild-keygen -a -i

RUN \
  mkdir zip && \
  cd zip && \
  wget https://raw.githubusercontent.com/alpinelinux/aports/master/main/zip/APKBUILD && \
  wget https://raw.githubusercontent.com/alpinelinux/aports/master/main/zip/40-fix-zipnote.patch && \
  wget https://raw.githubusercontent.com/alpinelinux/aports/master/main/zip/30-zip-3.0-pic.patch && \
  wget https://raw.githubusercontent.com/alpinelinux/aports/master/main/zip/20-zip-3.0-exec-stack.patch && \
  wget https://raw.githubusercontent.com/alpinelinux/aports/master/main/zip/10-zip-3.0-build.patch && \
  abuild checksum && \
  abuild -rkK && \
  cd ..


# The following binaries will be available:
# - zip
# - zipcloak
# - zipnote
# - zipsplit
FROM scratch
COPY --from=builder /packager/zip/pkg/zip/usr/bin/* /
ENTRYPOINT ["/zip"]
CMD ["-h"]
