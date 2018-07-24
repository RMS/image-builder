# CircleCI image builder tests

This directory contains the tests we will execute against the base CircleCI build image to ensure its correctness. The idea is that these tests will run against a newly built base CircleCI image prior to that image being pushed out to Artifactory. This helps ensure that we do not push out a defective image to the CircleCI worker nodes which would cause disruption to developer builds. 


## Process overview

Images will be built whenever a commit is pushed to a branch of the `image-builder` repo. That image will be tagged with the name of the branch that is being built from, such as `eastus-artifactory.azure.rmsonecloud.net:6001/buildbox:feature_branch`. Once built, the test suite will build a temporary test container using that image and run the test suite against that container. If the tests pass, the image will then be pushed to artifactory. If the tests do not pass, the build will fail and no image will be pushed.

As usual, if the branch pushed to is the primary `rms-master` branch, the image will be given the tag `latest` before it is pushed (if all tests pass)


## Testing framework

The `testinfra` framework is used for running the tests: http://testinfra.readthedocs.io/en/latest/
