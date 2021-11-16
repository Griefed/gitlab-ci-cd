### [1.0.4](https://git.griefed.de/prosper/gitlab-ci-cd/compare/1.0.3...1.0.4) (2021-11-16)


### 🛠 Fixes

* No pr limit for renovate bot ([a15ffc0](https://git.griefed.de/prosper/gitlab-ci-cd/commit/a15ffc0f7fcd775049ddbc7f50e6ab43efc365ad))


### Other

* **deps:** update griefed/gitlab-ci-cd docker tag to v1.0.3 ([f8d8f54](https://git.griefed.de/prosper/gitlab-ci-cd/commit/f8d8f54e39ae8ceb23aae57f97ecd27812354069))

### [1.0.3](https://git.griefed.de/prosper/gitlab-ci-cd/compare/1.0.2...1.0.3) (2021-10-15)


### 🦊 CI/CD

* Update ci-cd image to 1.0.2 ([5536a5e](https://git.griefed.de/prosper/gitlab-ci-cd/commit/5536a5eedf38575ae40dd1bd2fac35be730effe0))


### 🛠 Fixes

* Update nodejs and npm ([2609aa1](https://git.griefed.de/prosper/gitlab-ci-cd/commit/2609aa1b918c42d2f0f68e3772f0e0e739707558))

### [1.0.2](https://git.griefed.de/prosper/gitlab-ci-cd/compare/1.0.1...1.0.2) (2021-10-15)


### 🛠 Fixes

* Use stable-dind as 19.03 did not support armv7 ([3cd7e86](https://git.griefed.de/prosper/gitlab-ci-cd/commit/3cd7e86b5fe4180b1d01d90df60d35b0da85b33d))


### Other

* Add GitLab issue templates ([ef94283](https://git.griefed.de/prosper/gitlab-ci-cd/commit/ef94283e4561e57d9e10f05be08340c6244baf23))
* **deps:** update griefed/gitlab-ci-cd docker tag to v1.0.1 ([990877c](https://git.griefed.de/prosper/gitlab-ci-cd/commit/990877c341f0c6219123f36e5a6dd3fae9dc859b))

### [1.0.1](https://git.griefed.de/prosper/gitlab-ci-cd/compare/1.0.0...1.0.1) (2021-07-10)


### 🦊 CI/CD

* Switch image to gitlab-ci-cd which provides for all jobs ([90e78d4](https://git.griefed.de/prosper/gitlab-ci-cd/commit/90e78d4755006b79d1787f8331237615db27f9a6))


### 🛠 Fixes

* Enable docker experimental features to allow for manifest manipulation ([0a7f99a](https://git.griefed.de/prosper/gitlab-ci-cd/commit/0a7f99af63801facf5e6ae6d6629fe70dbe0b6dc))


### Other

* List DIND as well ([975025a](https://git.griefed.de/prosper/gitlab-ci-cd/commit/975025aa92eb9568793ee52f16e437fab3a99691))

## [1.0.0](https://git.griefed.de/prosper/gitlab-ci-cd/compare/...1.0.0) (2021-07-10)


### 🦊 CI/CD

* Switch to image which supports our architectures ([62022aa](https://git.griefed.de/prosper/gitlab-ci-cd/commit/62022aa5a58818388c4fe6147d427aae22aedc59))
* Write Dockerfile ([76aa77a](https://git.griefed.de/prosper/gitlab-ci-cd/commit/76aa77a320c8a4b9ec23761a06e19f688cbb96e4))
* Add GitHub release workflow for release "mirroring" from GitLab to GitHub on tag push ([2acd966](https://git.griefed.de/prosper/gitlab-ci-cd/commit/2acd966f0df28aeb210242071805e5fcea0e50ad))
* Add gitlab-ci config ([6e7c554](https://git.griefed.de/prosper/gitlab-ci-cd/commit/6e7c554003369752b6bdb047e69eb81facf08bd4))
* Add RenovateBot config ([8457d0d](https://git.griefed.de/prosper/gitlab-ci-cd/commit/8457d0d12cc21bcc75cec8f73dcc1ee53fe209b8))
* Add sem-rel config ([59aa800](https://git.griefed.de/prosper/gitlab-ci-cd/commit/59aa80015e535e85df1e0b50e7dc203301018714))
* Fix branch ([440b762](https://git.griefed.de/prosper/gitlab-ci-cd/commit/440b7620cb7d2664861c48d024677bbd2371ef7d))


### 🧪 Tests

* Split into separate RUN blocks to identify cause of failing build ([7fa6e0b](https://git.griefed.de/prosper/gitlab-ci-cd/commit/7fa6e0bede972d0a1058280a11bbf7c8ca6f21bc))


### 🛠 Fixes

* Remove unnecessary argument ([1e34771](https://git.griefed.de/prosper/gitlab-ci-cd/commit/1e34771b85868ae4bb76e760a58078d88f6375d5))


### Other

* Let the ignores hit the floor. Let the ignores hit the floor. Let the ignores hit the......GITIGNOOOOOOOOOOOOORE ([0feeffb](https://git.griefed.de/prosper/gitlab-ci-cd/commit/0feeffbd99bea656c00594fe74c0506d58faff11))
* Provide some details on what is inside this image ([989c8e0](https://git.griefed.de/prosper/gitlab-ci-cd/commit/989c8e0bcd0867a3da55ab269872e421e6eed547))
