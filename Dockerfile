FROM eastus-artifactory.azure.rmsonecloud.net:6001/buildbox:buildbox-base

USER ubuntu
WORKDIR /home/ubuntu
COPY settings.xml .m2/
COPY repos/data-store /home/ubuntu/data-store-prime

RUN sudo chown -R ubuntu:ubuntu data-store-prime && \
        sudo chown -R ubuntu:ubuntu /home/ubuntu/.m2

RUN /bin/bash -c 'source ~/.bash_profile && cd /home/ubuntu/data-store-prime \
        && mvn dependency:go-offline \
        && rm -rf /home/ubuntu/data-store-prime/target'

USER root
CMD ["/sbin/init"]