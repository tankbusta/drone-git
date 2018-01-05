FROM plugins/base:amd64
MAINTAINER Drone.IO Community <drone-dev@googlegroups.com>

LABEL org.label-schema.version=latest
LABEL org.label-schema.vcs-url="https://github.com/drone-plugins/drone-git.git"
LABEL org.label-schema.name="Drone Git"
LABEL org.label-schema.vendor="Drone.IO Community"
LABEL org.label-schema.schema-version="1.0"

RUN apk add --no-cache ca-certificates git openssh curl perl

RUN lfs_version=2.3.4 && \
    lfs_sha256=6755e109a85ffd9a03aacc629ea4ab1cbb8e7d83e41bd1880bf44b41927f4cfe && \
    mkdir /tmp/${lfs_version} && \
    curl -o "/tmp/git-lfs-linux-amd64-${lfs_version}.tar.gz" -L "https://github.com/git-lfs/git-lfs/releases/download/v${lfs_version}/git-lfs-linux-amd64-${lfs_version}.tar.gz" \
    && [ "$(sha256sum /tmp/git-lfs-linux-amd64-${lfs_version}.tar.gz | awk '{print $1'})" = ${lfs_sha256} ]  && echo "sha256 ok" || exit 1 \
    && tar xvzf "/tmp/git-lfs-linux-amd64-${lfs_version}.tar.gz" -C /tmp \
    && mv "/tmp/git-lfs-${lfs_version}/git-lfs" /bin/git-lfs \
    && git lfs install \
    && unset lfs_version lfs_sha256 \
    && rm -r /tmp/${lfs_version}

ADD release/linux/amd64/drone-git /bin/
ENTRYPOINT ["/bin/drone-git"]
