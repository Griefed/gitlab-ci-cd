FROM alpine AS fetcher

RUN \
  apk add \
    curl && \
  LATEST_DOCKERX=$(curl --silent "https://api.github.com/repos/docker/buildx/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | cut -c 2-) && \
  curl \
    -L \
    --output /docker-buildx \
      "https://github.com/docker/buildx/releases/download/v${LATEST_DOCKERX}/buildx-v${LATEST_DOCKERX}.linux-amd64" && \
  chmod a+x \
    /docker-buildx

FROM docker:stable-dind

LABEL maintainer="Griefed <griefed@griefed.de>"
LABEL description="Provides GitLab Semantic Release, buildx, JDK 8, NodeJS for Griefed's GitLab CI/CD pipelines."

COPY --from=fetcher /docker-buildx /usr/lib/docker/cli-plugins/docker-buildx

ENV DOCKER_CLI_EXPERIMENTAL=enabled

RUN \
  echo "**** Updating and installing our packages ****" && \
  apk update && \
  apk upgrade && \
  apk add --no-cache \
    bash \
    ca-certificates \
    curl \
    git \
    nodejs \
    npm \
    openjdk8 && \
  echo "**** Installing GitLab Semantic Release ****" && \
  npm install -g \
    conventional-changelog-conventionalcommits \
    semantic-release \
    @semantic-release/changelog \
    @semantic-release/commit-analyzer \
    @semantic-release/exec \
    @semantic-release/git \
    @semantic-release/gitlab \
    @semantic-release/npm \
    @semantic-release/release-notes-generator && \
  echo "**** Making docker-buildx executable for all ****" && \
  chmod a+x \
    /usr/lib/docker/cli-plugins/docker-buildx && \
  echo "**** Installing quasar ****" && \
  npm install -g \
    @quasar/cli && \
  echo "**** Cleanup ****" && \
  rm -rf \
    /var/cache/apk/* \
    /tmp/*
