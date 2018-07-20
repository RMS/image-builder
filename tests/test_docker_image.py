import os
import subprocess

import pytest
import testinfra


@pytest.fixture(scope='session')
def host():
    # TODO Pass in the image name/ID that was just built
    docker_id = subprocess.check_output(
        'sudo docker run -d --name test -e GIT_CRYPT_KEY={} eastus-artifactory.azure.rmsonecloud.net:6001/buildbox:{} sleep 90'.format(os.environ['GIT_CRYPT_KEY'], os.environ['TAG']).split()).decode().strip()
    # Note I am setting it to use the `ubuntu` user specifically below because the default user is `root`
    # TODO Should we change the image to just default to the `ubuntu` user?
    yield testinfra.get_host("docker://ubuntu@" + docker_id)
    subprocess.check_call(['sudo', 'docker', 'rm', '-f', docker_id])


def test_default_user(host):
    user = host.user()
    assert user.name == 'ubuntu'


def test_rms_one_deployment_directory_permissions(host):
    rms_one_deployment_directory = host.file('/home/ubuntu/rms-one-deployment')
    assert rms_one_deployment_directory.is_directory
    assert rms_one_deployment_directory.user == 'ubuntu'
    assert rms_one_deployment_directory.group == 'ubuntu'
    assert oct(rms_one_deployment_directory.mode) == '0o755'


def test_git_crypt(host):
    assert host.exists('git-crypt')  # Make sure the command exists and is on the PATH
    assert host.run('/home/ubuntu/rms-one-deployment/scripts/ci-unlock;').rc == 0
