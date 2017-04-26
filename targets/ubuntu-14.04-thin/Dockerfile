FROM circleci/ubuntu-server:trusty-latest

ENV VERBOSE true

ADD circleci-install /usr/local/bin/circleci-install
ADD circleci-provision-scripts/rms.sh /opt/circleci-provision-scripts/rms.sh
ADD circleci-provision-scripts/base.sh circleci-provision-scripts/circleci-specific.sh /opt/circleci-provision-scripts/
RUN circleci-install base_requirements && circleci-install circleci_specific

ARG use_precompile=true
ENV USE_PRECOMPILE=$use_precompile RUN_APT_UPDATE=true
RUN curl -s https://packagecloud.io/install/repositories/circleci/trusty/script.deb.sh | sudo bash

ADD circleci-provision-scripts/python.sh /opt/circleci-provision-scripts/python.sh
RUN circleci-install python 2.7.12
RUN circleci-install python 3.5.2
RUN sudo -H -i -u ubuntu pyenv global 3.5.2

RUN circleci-install rms


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

ADD circleci-provision-scripts/docker.sh /opt/circleci-provision-scripts/docker.sh
RUN circleci-install docker && circleci-install docker_compose
RUN circleci-install circleci_docker


USER ubuntu

CMD ["/bin/bash"]

LABEL circleci.user="ubuntu"
