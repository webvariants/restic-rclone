FROM    debian

MAINTAINER Martin Schnabel <martin@webvariants.de>

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache && \
    apt-get -q update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -q -y curl apache2-utils openssl unzip man-db

RUN TRIGGER_MIN_VERSION=1.43 curl https://rclone.org/install.sh | bash

RUN useradd -ms /bin/bash rclone

COPY entrypoint.sh /entrypoint.sh

USER rclone

RUN mkdir -p /home/rclone/.config/rclone

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

ENV SERVE_PARAMS /data

CMD ["serve"]
