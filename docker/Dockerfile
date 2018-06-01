FROM    debian

MAINTAINER Martin Schnabel <martin@webvariants.de>

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache && \
    apt-get update && \
    apt-get install -y curl apache2-utils openssl && \
    curl -sL https://downloads.rclone.org/v1.41/rclone-v1.41-linux-amd64.deb -o rclone.deb && \
    dpkg -i rclone.deb && \
    rm rclone.deb && \
    useradd -ms /bin/bash rclone

COPY entrypoint.sh /entrypoint.sh

USER rclone

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

ENV SERVE_PARAMS /data

CMD ["serve"]
