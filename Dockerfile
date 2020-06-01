FROM ubuntu:19.10
MAINTAINER forsrc@gmail.com

ENV DEBIAN_FRONTEND=noninteractive
ARG USER
ENV USER=${USER:-forsrc}
ARG PASSWD
ARG PASSWD=${PASSWD:-forsrc}

RUN apt-get update  -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false
RUN apt-get install -y sudo systemd

RUN useradd -m --shell /bin/bash $USER && \
    echo "$USER:$PASSWD" | chpasswd && \
    echo "$USER ALL=(ALL) ALL" >> /etc/sudoers

RUN apt-get clean

RUN echo  "#\!/bin/sh" | sed -e "s/\\\\//g" >  /start.sh
RUN echo echo [start...]                    >> /start.sh
RUN echo echo [end.....]                    >> /start.sh
RUN chmod +x /start.sh
RUN cat /start.sh 1>&2

#COPY entrypoint.sh /
RUN echo  "#\!/bin/sh" | sed -e "s/\\\\//g" >  /entrypoint.sh
RUN echo /start.sh                          >> /entrypoint.sh
RUN echo exec \"\$@\"                       >> /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN cat /entrypoint.sh 1>&2

ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /home/$USER
USER $USER


CMD [ \
    "/sbin/init" \
]
