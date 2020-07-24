FROM canal/otter-osbase:v1

MAINTAINER agapple (jianghang115@gmail.com)

# install otter
COPY image/ /tmp/docker/
COPY app.sh /home/admin/
COPY config.sh /home/admin/
COPY manager.deployer-*.tar.gz /home/admin/

RUN \
    cp -R /tmp/docker/alidata /alidata && \
    chmod +x /alidata/bin/* && \
    mkdir -p /home/admin && \
    /bin/cp -f alidata/bin/lark-wait /usr/bin/lark-wait && \
    mkdir -p /home/admin/manager && \
    tar -xzvf /home/admin/manager.deployer-*.tar.gz -C /home/admin/manager && \
    /bin/rm -f /home/admin/manager.deployer-*.tar.gz && \
    mkdir -p home/admin/manager/logs  && \
    chmod +x /home/admin/*.sh  && \
    chown admin: -R /home/admin && \
    sh config.sh 1>>/tmp/manager.log 2>&1 && \
    yum clean all && \
    true

WORKDIR /home/admin

ENTRYPOINT [ "/alidata/bin/main.sh" ]
ENTRYPOINT [ "/home/admin/app.sh" ]
CMD [ "/bin/bash" ]
