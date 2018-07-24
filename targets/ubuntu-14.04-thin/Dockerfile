FROM circleci/ubuntu-server:trusty-latest

ENV VERBOSE true

# Avoid any installation scripts interact with upstart
# So divert now, but undivert at the end
# You shouldn't change the line unless you understand the consequence
RUN echo 'exit 101' > /usr/sbin/policy-rc.d \
	&& chmod +x /usr/sbin/policy-rc.d \
        && dpkg-divert --local --rename --add /sbin/initctl \
        && ln -s /bin/true /sbin/initctl

ADD circleci-install /usr/local/bin/circleci-install
ADD circleci-provision-scripts/base.sh circleci-provision-scripts/circleci-specific.sh /opt/circleci-provision-scripts/
RUN circleci-install base_requirements && circleci-install circleci_specific

ARG use_precompile=true
ENV USE_PRECOMPILE=$use_precompile RUN_APT_UPDATE=true
RUN curl -s https://packagecloud.io/install/repositories/circleci/trusty/script.deb.sh | sudo bash

ADD circleci-provision-scripts/python.sh /opt/circleci-provision-scripts/python.sh
RUN circleci-install python 2.7.12
RUN circleci-install python 3.6.4
RUN sudo -H -i -u ubuntu pyenv global 3.6.4
ADD tests/requirements.txt tests/requirements.txt
RUN pip install -r tests/requirements.txt

ADD circleci-provision-scripts/nodejs.sh /opt/circleci-provision-scripts/nodejs.sh
RUN circleci-install nodejs 6.1.0
RUN sudo -H -i -u ubuntu nvm alias default 6.1.0

ADD circleci-provision-scripts/java.sh /opt/circleci-provision-scripts/java.sh
RUN circleci-install java oraclejdk8 && circleci-install java openjdk8

ADD circleci-provision-scripts/scala.sh /opt/circleci-provision-scripts/scala.sh
RUN circleci-install scala

ADD circleci-provision-scripts/go.sh /opt/circleci-provision-scripts/go.sh
RUN circleci-install golang 1.6.2

ADD circleci-provision-scripts/postgres.sh  /opt/circleci-provision-scripts/postgres.sh
RUN circleci-install postgres
RUN circleci-install postgres_ext_postgis

ADD circleci-provision-scripts/docker.sh /opt/circleci-provision-scripts/docker.sh
RUN circleci-install docker && circleci-install docker_compose
RUN circleci-install circleci_docker

ADD circleci-provision-scripts/rms.hcl /opt/rms.hcl
ADD circleci-provision-scripts/rms.sh /opt/circleci-provision-scripts/rms.sh
RUN circleci-install rms
ADD circleci-provision-scripts/misc.sh /opt/circleci-provision-scripts/misc.sh
RUN circleci-install redis
#RUN sudo service redis-server start

ADD circleci-provision-scripts/firefox.sh circleci-provision-scripts/chrome.sh /opt/circleci-provision-scripts/
RUN circleci-install firefox && circleci-install chrome

# Undivert upstart
# You shouldn't change the line unless you understad the consequence
RUN rm /usr/sbin/policy-rc.d && rm /sbin/initctl && dpkg-divert --rename --remove /sbin/initctl

ARG IMAGE_TAG
RUN echo $IMAGE_TAG > /opt/circleci/image_version

LABEL circleci.user="ubuntu"

RUN echo 'source /home/ubuntu/.circlerc &>/dev/null' >> /root/.bashrc

ADD rms-one-deployment /home/ubuntu/rms-one-deployment
RUN chown -R ubuntu:ubuntu /home/ubuntu/rms-one-deployment
RUN sudo -H -i -u ubuntu /home/ubuntu/rms-one-deployment/scripts/ci-image-setup

USER root

CMD ["/sbin/init"]
