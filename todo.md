# TODO

* keep repoPath parameter
  -> also as environment variable

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

* Generate and use Helm charts

## Done

* Add script that installs into /usr/local/bin
