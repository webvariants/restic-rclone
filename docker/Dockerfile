FROM    debian

MAINTAINER Martin Schnabel <martin@webvariants.de>

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache && \
    apt-get -q update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -q -y curl apache2-utils openssl unzip

ENV RCLONE_VERSION=1.42

RUN curl https://downloads.rclone.org/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-amd64.zip -o /rclone.zip && \
    mkdir /rclone && \
    unzip -a /rclone.zip -d /rclone && \
    cd /rclone/* && \
    mv rclone /usr/local/bin && \
    rm -rf /rclone* && \
    useradd -ms /bin/bash rclone

COPY entrypoint.sh /entrypoint.sh

USER rclone

RUN mkdir -p /home/rclone/.config/rclone

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

ENV SERVE_PARAMS /data

CMD ["serve"]
