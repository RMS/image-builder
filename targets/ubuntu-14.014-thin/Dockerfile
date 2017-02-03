FROM circleci/ubuntu-server:trusty-latest

ENV VERBOSE true

ADD circleci-install /usr/local/bin/circleci-install
ADD circleci-provision-scripts/rms.sh /opt/circleci-provision-scripts/
ADD circleci-provision-scripts/base.sh circleci-provision-scripts/circleci-specific.sh /opt/circleci-provision-scripts/
RUN circleci-install base_requirements && circleci-install circleci_specific

ADD circleci-provision-scripts/java.sh /opt/circleci-provision-scripts/java.sh
RUN circleci-install java oraclejdk8 && circleci-install java openjdk8

ADD circleci-provision-scripts/scala.sh /opt/circleci-provision-scripts/scala.sh
RUN circleci-install scala

RUN circleci-install python 2.7.12
RUN circleci-install python 3.5.2
RUN sudo -H -i -u ubuntu pyenv global 3.5.2

RUN circleci-install nodejs 4.2.6
RUN sudo -H -i -u ubuntu nvm alias default 4.2.6

ADD circleci-provision-scripts/go.sh /opt/circleci-provision-scripts/go.sh
RUN circleci-install golang 1.6.2

RUN circleci-install rms

USER ubuntu

CMD ["/bin/bash"]

LABEL circleci.user="ubuntu"
