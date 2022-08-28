# Sources, GitHub, GitLab and Mirroring and all that good stuff

Repositories on GitHub are now for issues only. I've set up my own installation of GitLab and moved all my repositories over to [Git.Griefed.de](https://git.griefed.de/users/Griefed/projects). Make sure to check there first for the latest code before opening an issue on GitHub.

For questions, you can always join my [Discord server](https://discord.griefed.de) and talk to me there.

---

# gitlab-ci-cd
Provides GitLab Semantic Release, buildx, JDK 8, NodeJS for Griefed's GitLab CI/CD pipelines.

Combines:
- [docker-buildx](https://git.griefed.de/prosper/docker-with-buildx)
- JDK8
- [GitLab Semantic Release](https://git.griefed.de/prosper/gitlab-semantic-release)
- NodeJS
- Docker-in-Docker
- [discord.sh](https://github.com/ChaoticWeg/discord.sh)
- git
- [act](https://github.com/nektos/act)

# act

act requires a `.actrc`-file to be present in the executing users home directory, so `~/.actrc`. For information about the contents and configuration of this file, see [nektos/act#first-run](https://github.com/nektos/act#first-act-run) and [nektos/act#configuration](https://github.com/nektos/act#configuration)

# discord.sh example

## GitLab

:warning: **Requires CI/CD variable `AVATAR_IMAGE_URL`**

:warning: **Requires CI/CD variable `AUTHOR_ICON_URL`**

:warning: **Requires CI/CD variable `IMAGE_URL`**

:warning: **Requires CI/CD variable `THUMBNAIL_URL`**

:warning: **Requires CI/CD variable `FOOTER_ICON_URL`**

```yml
Inform About Release:
  stage: Build Release
  image: ghcr.io/griefed/gitlab-ci-cd:2.0.9
  needs:
    - job: Build Release
      artifacts: false
    - job: Build Docker Release
      artifacts: false
      optional: true
    - job: Build Docker PreRelease
      artifacts: false
      optional: true
  script:
    - /discord.sh
      --webhook-url="$WEBHOOK_URL"
      --username "$CI_PROJECT_TITLE"
      --avatar "${AVATAR_IMAGE_URL}"
      --text "There's been a new release for ${CI_PROJECT_TITLE}. The new version is ${CI_COMMIT_TAG} and is available at <${CI_PROJECT_URL}/-/releases/${CI_COMMIT_TAG}>"
      --title "New ${CI_PROJECT_TITLE} Release"
      --description "There's been a new release for ${CI_PROJECT_TITLE}. The new version is ${CI_COMMIT_TAG} and is available at ${CI_PROJECT_URL}/-/releases/${CI_COMMIT_TAG}"
      --color "0xC0FFEE"
      --url "${CI_PROJECT_URL}/-/releases/${CI_COMMIT_TAG}"
      --author "${CI_PROJECT_NAMESPACE}"
      --author-url "https://${CI_SERVER_HOST}/${CI_PROJECT_NAMESPACE}"
      --author-icon "${AUTHOR_ICON_URL}"
      --image "${IMAGE_URL}"
      --thumbnail "${THUMBNAIL_URL}"
      --field "Author;[${CI_PROJECT_NAMESPACE}](https://${CI_SERVER_HOST}/${CI_PROJECT_NAMESPACE})"
      --field "Platform;[${CI_SERVER_HOST}](https://${CI_SERVER_HOST})"
      --footer "Released at $CI_JOB_STARTED_AT"
      --footer-icon "${FOOTER_ICON_URL}"
  rules:
    - if: '$CI_COMMIT_TAG =~ /^\d+\.\d+\.\d+-(alpha|beta)\.\d+$/'
    - if: '$CI_COMMIT_TAG =~ /^\d+\.\d+\.\d+$/'
```

## Example

![embed](https://i.griefed.de/images/2022/08/04/grafik.png)

# buildx Example

```yml
test docker:
  stage: test
  image: ghcr.io/griefed/gitlab-ci-cd:2.0.9
  before_script:
    - docker login -u "$DOCKERHUB_USER" -p "$DOCKERHUB_TOKEN" docker.io
    - docker login -u "$CI_REGISTRY_USER" -p "$CI_REGISTRY_PASSWORD" $CI_REGISTRY
    - docker login -u "$DOCKERHUB_USER" -p "$GITHUB_TOKEN" ghcr.io
    - docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
    - docker buildx create --use --name grfdbuilder
  script:
    - docker buildx build
      --push
      --no-cache
      --platform linux/amd64,linux/arm64,linux/arm/v7
      --tag "index.docker.io/$DOCKERHUB_USER/$DOCKERHUB_REPO:develop-$CI_COMMIT_SHORT_SHA"
      --tag "ghcr.io/$DOCKERHUB_USER/$DOCKERHUB_REPO:develop-$CI_COMMIT_SHORT_SHA" .
  except:
    refs:
      - tags
    variables:
      - '$CI_COMMIT_TITLE =~ /^RELEASE:.+$/ || $CI_PIPELINE_SOURCE == "schedule"'
```

# GitLab Semantic Release example

## Setup 

:warning: **Requires CI/CD variable `GITLAB_TOKEN` with personal-access-token (read/write permision to registry and repository).**

:warning: **Requires CI/CD variable `DOCKERHUB_USER` with lowercase username of the Dockerhub repository owner where the image will be pushed to.**

:warning: **Requires CI/CD variable `DOCKERHUB_REPO` with lowercase name of the Dockerhub repository where the image will be pushed to.**

:warning: **Requires CI/CD variable `DOCKERHUB_TOKEN` with personal-access-token to Docherhub.**

Currently it's doing:
- bump up semantic version (major/minor/patch) according to commits 
- create tag with release version
- create release for new tag
- update [CHANGELOG.md](CHANGELOG.md) with release notes generated from commits
- commit & push all above steps

## Example configs

### GitLab Runner config.toml

Example config.toml for a GitLab-Runner which works with a dockerized GitLab and multiarch Docker images using buildx:

```toml
concurrent = 1
check_interval = 0

[session_server]
  session_timeout = 1800

[[runners]]
  name = "Runner-One"
  url = "https://url.to.your.gitlab"
  token = "token_generated_by_runner_registration"
  executor = "docker"
  environment = ["DOCKER_TLS_CERTDIR="]
  [runners.custom_build_dir]
  [runners.cache]
    [runners.cache.s3]
    [runners.cache.gcs]
    [runners.cache.azure]
  [runners.docker]
    tls_verify = false
    image = "ubuntu:20.04"
    privileged = true
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    cache_dir = "/cache"
    volumes = ["/var/run/docker.sock:/var/run/docker.sock", "/cache"]
    shm_size = 0
```

### GitLab .gitlab-ci.yml

Example of a GitLab CI comosed of three stages: test, release and build

```yml
stages:
  - test
  - release
  - build

services:
  - name: ghcr.io/griefed/gitlab-ci-cd:2.0.9
    alias: docker

image: ghcr.io/griefed/gitlab-ci-cd:2.0.9

variables:
  project_name: $CI_PROJECT_NAME
  SEMANTIC_RELEASE_PACKAGE: $CI_PROJECT_NAME

workflow:
  rules:
    - if: '$CI_MERGE_REQUEST_EVENT_TYPE == "detached"'
      when: never
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      when: never
    - when: always

test docker:
  stage: test
  image: ghcr.io/griefed/gitlab-ci-cd:2.0.9
  before_script:
    - docker login -u "$DOCKERHUB_USER" -p "$DOCKERHUB_TOKEN" docker.io
    - docker login -u "$CI_REGISTRY_USER" -p "$CI_REGISTRY_PASSWORD" $CI_REGISTRY
    - docker login -u "$DOCKERHUB_USER" -p "$GITHUB_TOKEN" ghcr.io
    - docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
    - docker buildx create --use --name grfdbuilder
  script:
    - docker buildx build
      --push
      --no-cache
      --platform linux/amd64,linux/arm64,linux/arm/v7
      --tag "index.docker.io/$DOCKERHUB_USER/$DOCKERHUB_REPO:develop-$CI_COMMIT_SHORT_SHA"
      --tag "ghcr.io/$DOCKERHUB_USER/$DOCKERHUB_REPO:develop-$CI_COMMIT_SHORT_SHA" .
  except:
    refs:
      - tags
    variables:
      - '$CI_COMMIT_TITLE =~ /^RELEASE:.+$/ || $CI_PIPELINE_SOURCE == "schedule"'

release:
  needs: ['test docker']
  image: ghcr.io/griefed/gitlab-ci-cd:2.0.9
  stage: release
  script:
    - npx semantic-release
  only:
    - main
  except:
    refs:
      - tags
    variables:
      - '$CI_COMMIT_TITLE =~ /^RELEASE:.+$/ || $CI_PIPELINE_SOURCE == "schedule"'

build:
  stage: build
  image: ghcr.io/griefed/gitlab-ci-cd:2.0.9
  before_script:
    - docker login -u "$DOCKERHUB_USER" -p "$DOCKERHUB_TOKEN" docker.io
    - docker login -u "$CI_REGISTRY_USER" -p "$CI_REGISTRY_PASSWORD" $CI_REGISTRY
    - docker login -u "$DOCKERHUB_USER" -p "$GITHUB_TOKEN" ghcr.io
    - docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
    - docker buildx create --use --name grfdbuilder
  script:
    - docker buildx build
      --push
      --no-cache
      --platform linux/amd64,linux/arm64,linux/arm/v7
      --tag "ghcr.io/$DOCKERHUB_USER/$DOCKERHUB_REPO:$CI_COMMIT_TAG"
      --tag "ghcr.io/$DOCKERHUB_USER/$DOCKERHUB_REPO:latest"
      --tag "index.docker.io/$DOCKERHUB_USER/$DOCKERHUB_REPO:$CI_COMMIT_TAG"
      --tag "index.docker.io/$DOCKERHUB_USER/$DOCKERHUB_REPO:latest" .
  only:
    - tags
```

### Semantic-Release .releaserc.yml

Example config for changelog, tag and release generating config file using conventional commits.

```yml
branches: ['master','main']
ci: true
debug: true
dryRun: false
tagFormat: '${version}'

# Global plugin options (will be passed to all plugins)
preset: 'conventionalcommits'
gitlabUrl: 'https://git.griefed.de/' # your gitlab url

# Responsible for verifying conditions necessary to proceed with the release:
# configuration is correct, authentication token are valid, etc...
verifyConditions:
  - '@semantic-release/changelog'
  - '@semantic-release/git'
  - '@semantic-release/gitlab'

# Responsible for determining the type of the next release (major, minor or patch).
# If multiple plugins with a analyzeCommits step are defined, the release type will be
# the highest one among plugins output.
# Look details at: https://github.com/semantic-release/commit-analyzer#configuration
analyzeCommits:
  - path: '@semantic-release/commit-analyzer'
    releaseRules:
      - type: breaking  # Changes that break something makes something incompatible to ealier version
        release: major
      - type: build     # Changes that affect the build system or external dependencies
        release: patch
      - type: chore     # Other changes that don't modify src or test files
        release: false
      - type: ci        # Changes to our CI configuration files and scripts
        release: false
      - type: docs      # Documentation only changes
        release: false
      - type: feat      # A new feature
        release: minor
      - type: fix       # A bug fix
        release: patch
      - type: perf      # A code change that improves performance
        release: patch
      - type: refactor  # A code change that neither fixes a bug nor adds a feature
        release: false
      - type: revert    # Reverts a previous commit
        release: patch
      - type: style     # Changes that do not affect the meaning of the code
        release: false
      - type: test      # Adding missing tests or correcting existing tests
        release: false

# Responsible for generating the content of the release note.
# If multiple plugins with a generateNotes step are defined,
# the release notes will be the result of the concatenation of each plugin output.
generateNotes:
  - path: '@semantic-release/release-notes-generator'
    writerOpts:
      groupBy: 'type'
      commitGroupsSort: 'title'
      commitsSort: 'header'
    linkCompare: true
    linkReferences: true
    presetConfig:
      types:  # looks like it only works with 'conventionalcommits' preset
        - type: 'build'
          section: '🦊 CI/CD'
          hidden: false
        - type: 'chore'
          section: 'Other'
          hidden: false
        - type: 'ci'
          section: '🦊 CI/CD'
          hidden: false
        - type: 'docs'
          section: '📔 Docs'
          hidden: false
        - type: 'example'
          section: '📝 Examples'
          hidden: false
        - type: 'feat'
          section: '🚀 Features'
          hidden: false
        - type: 'fix'
          section: '🛠 Fixes'
          hidden: false
        - type: 'perf'
          section: '⏩ Performance'
          hidden: false
        - type: 'refactor'
          section: ':scissors: Refactor'
          hidden: false
        - type: 'revert'
          section: '👀 Reverts'
          hidden: false
        - type: 'style'
          section: '💈 Style'
          hidden: false
        - type: 'test'
          section: '🧪 Tests'
          hidden: false

# Responsible for preparing the release, for example creating or updating files
# such as package.json, CHANGELOG.md, documentation or compiled assets
# and pushing a commit.
prepare:
  # - path: '@semantic-release/exec'
  #   # Execute shell command to set package version
  #   cmd: './deployment/version-plaintext-set.sh ${nextRelease.version}'
  # - path: '@semantic-release/exec'
  #   cmd: './deployment/version-oas-set.sh ${nextRelease.version} openapi.yaml'
  # - path: '@semantic-release/exec'
  #   verifyReleaseCmd: "echo ${nextRelease.version} > VERSION.txt"
  - path: '@semantic-release/changelog'
    # Create or update the changelog file in the local project repository
  - path: '@semantic-release/git'
    # Push a release commit and tag, including configurable files
    message: 'RELEASE: ${nextRelease.version}'
    assets: ['CHANGELOG.md']

# Responsible for publishing the release.
publish:
  - path: '@semantic-release/gitlab'
    # Publish a GitLab release
    #  (https://docs.gitlab.com/ce/user/project/releases/index.html#add-release-notes-to-git-tags)

success: false

fail: false
```
