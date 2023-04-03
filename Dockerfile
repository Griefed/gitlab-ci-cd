FROM alpine AS fetcher

RUN \
  apk add \
    curl && \
  LATEST_DOCKERX=$(curl --silent "https://api.github.com/repos/docker/buildx/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | cut -c 2-) && \
  echo "**** Acquire docker-buildx" && \
    curl \
      -L \
      --output /docker-buildx \
        "https://github.com/docker/buildx/releases/download/v${LATEST_DOCKERX}/buildx-v${LATEST_DOCKERX}.linux-amd64" && \
    chmod a+x \
      /docker-buildx && \
  echo "**** Acquire discord.sh from ChaoticWeg/discord.sh" && \
    curl \
      -L \
      --output /discord.sh \
        https://raw.githubusercontent.com/ChaoticWeg/discord.sh/master/discord.sh && \
    chmod a+x \
      /discord.sh

FROM mazzolino/docker:20.10.12-dind

LABEL maintainer="Griefed <griefed@griefed.de>"
LABEL description="Provides GitLab Semantic Release, buildx, JDK 8, NodeJS for Griefed's GitLab CI/CD pipelines."

COPY --from=fetcher /docker-buildx  /usr/lib/docker/cli-plugins/docker-buildx
COPY --from=fetcher /discord.sh     /discord.sh

ENV DOCKER_CLI_EXPERIMENTAL=enabled

RUN \
  echo "**** Updating and installing our packages ****" && \
  apk update && \
  apk upgrade && \
  apk add --no-cache \
    --repository https://dl-cdn.alpinelinux.org/alpine/v3.17/main/ \
    nodejs \
    npm && \
  apk add --no-cache \
    bash \
    ca-certificates \
    curl \
    git \
    jq \
    openjdk8 && \
  echo "node version is: " && \
    node -v && \
  echo "npm version is: " && \
    npm -v && \
  echo "updating npm..." && \
    npm update -g && \
  echo "node version is: " && \
    node -v && \
  echo "npm version is: " && \
    npm -v && \
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
  echo "**** Making docker-buildx and discord.sh executable for all ****" && \
  chmod a+x \
    /usr/lib/docker/cli-plugins/docker-buildx && \
  chmod a+x \
    /discord.sh && \
  echo "**** Installing quasar ****" && \
  npm install -g \
    @quasar/cli && \
  echo "**** Installing act ****" && \
    curl https://raw.githubusercontent.com/nektos/act/b23bbefc365012886192e477a88d38a0909ecba1/install.sh | bash && \
  echo "**** Cleanup ****" && \
  rm -rf \
    /var/cache/apk/* \
    /tmp/* \

