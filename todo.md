# TODO

* rename package to DopTool, swift-dop-tool

* interactive dop deploy, asks questions

* add lint command

* dop install
  - use it to install dop into /usr/local/bin

* Generate licenses

* dump the full descriptor (with default values)

* Write some tests

* colored CLI messages

* consider alternative name `cop` (cloud operator)

* Jobs
  - add a job to build the `reizu/ubuntu-build-swift` image
  - build-linux-release -> build-image
  - run-linux-release-locally -> run-image
  - push-docker-image.sh -> push-image
  - apply -> apply

  - deploy = {build-image, push-image, apply}
  - rollback
  - clean / reset
  - dump environment variables

* Generate and use Helm charts

## Done

* Add script that installs into /usr/local/bin
* generate helm chart
* keep repoPath parameter
  -> also as environment variable
