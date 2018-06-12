FROM eastus-artifactory.azure.rmsonecloud.net:6001/buildbox:prime-maven-cache

USER root
RUN cd /home/ubuntu \
    rm -rf data-store

