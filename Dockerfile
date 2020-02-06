FROM debian:stable-slim 

LABEL maintainer="Leonardo Amaral <docker@leonardoamaral.com.br>"

RUN printf "deb http://httpredir.debian.org/debian stable contrib\ndeb-src http://httpredir.debian.org/debian stable contrib" > /etc/apt/sources.list.d/non-free.list

RUN apt update &&\
    apt -y dist-upgrade &&\
    DEBIAN_FRONTEND=noninteractive apt -y install curl

RUN mkdir /lianetts_src &&\
    cd /lianetts_src &&\
    curl -sO http://intervox.nce.ufrj.br/~serpro/lianetts.tar.gz &&\
    tar --no-same-owner -xzf lianetts.tar.gz

RUN DEBIAN_FRONTEND=noninteractive apt -y install mbrola zenity build-essential alsa-utils

RUN cd /lianetts_src/liane_* &&\
    cd src &&\
    cc -o lianecomp *.c &&\
    mv lianecomp ../bin &&\
    cd .. &&\
    cp bin/* /usr/local/bin &&\
    cp -p 07/* /usr/local/bin &&\
    cp -R share/* /usr/share &&\
    chmod 666 /usr/share/lianetts/liane/lianetts.abr &&\
    chmod 666 /usr/share/lianetts/liane/lianetts.exc &&\
    mkdir -p /etc/speech-dispatcher/modules &&\
    cp spch_disp/lianetts-generic.conf /etc/speech-dispatcher/modules &&\
    cp spch_disp/speechd.conf /etc/speech-dispatcher &&\
    cat spch_disp/00-readme.txt

RUN DEBIAN_FRONTEND=noninteractive apt -y remove build-essential curl &&\
    apt-get -y autoremove &&\
    rm -rf /lianetts_src

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

WORKDIR /dados

CMD ['lianetts']
