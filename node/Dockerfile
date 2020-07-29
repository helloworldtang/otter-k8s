FROM canal/otter-osbase:v1

MAINTAINER tang.cheng (793059909@qq.com)

# install otter
COPY image/ /tmp/docker/
COPY app.sh /home/admin/
COPY node/ /home/admin/node

RUN \
    cp -R /tmp/docker/alidata /alidata && \
    chmod +x /alidata/bin/* && \
    mkdir -p /home/admin && \
    /bin/cp -f alidata/bin/lark-wait /usr/bin/lark-wait && \
    chmod +x /home/admin/*.sh  && \
    chown admin: -R /home/admin && \
    yum clean all && \
    true

ENV DOCKER_DEPLOY_TYPE=VM

WORKDIR /home/admin/node

ENTRYPOINT [ "/alidata/bin/main.sh" ]
CMD [ "/home/admin/app.sh" ]
