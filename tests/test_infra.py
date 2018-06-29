import subprocess

import pytest
import testinfra


@pytest.fixture(scope='session')
def host():
    # TODO Pass in the image name/ID that was just built
    docker_id = subprocess.check_output(
        'docker run -d --name test --rm eastus-artifactory.azure.rmsonecloud.net:6001/buildbox:latest sleep 5000'.split()).decode().strip()
    yield testinfra.get_host("docker://" + docker_id)
    subprocess.check_call(['docker', 'rm', '-f', docker_id])

# Test which user is the default when we run a container
# TODO Should we change to 'ubuntu'?
def test_default_user(host):
    user = host.user()
    assert user.name == 'root'


def test_rms_one_deployment_directory_permissions(host):
    rms_one_deployment_directory = host.file('/home/ubuntu/rms-one-deployment')
    assert rms_one_deployment_directory.is_directory
    assert rms_one_deployment_directory.user == 'ubuntu'
    assert rms_one_deployment_directory.group == 'ubuntu'
    assert oct(rms_one_deployment_directory.mode) == '0o755'


def test_git_decrypt(host):
    assert host.exists('git-crypt')  # Make sure the command exists and is on the PATH
    assert host.run('git-crypt').rc == 0  # TODO not working yet


