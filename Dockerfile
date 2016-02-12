FROM ubuntu:14.04
MAINTAINER Lars Kluge <l@larskluge.com>

RUN apt-get update
RUN dpkg-reconfigure locales && \
    locale-gen en_US.UTF-8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt-get -y install wget vim unzip

RUN adduser --disabled-password --home /ShellCoin --gecos "" ShellCoin
RUN echo "ShellCoin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /usr/local/src
RUN wget https://github.com/ShellCoin/ShellCoin/releases/download/v1.8.0/ShellCoin-1.8.0-linux64.zip
RUN unzip ShellCoin-1.8.0-linux64.zip
RUN chmod +x ShellCoind ShellCoin-cli
RUN ln -s /usr/local/src/ShellCoind /usr/local/bin/ShellCoind
RUN ln -s /usr/local/src/ShellCoin-cli /usr/local/bin/ShellCoin-cli

ADD ShellCoin.conf /ShellCoin/.ShellCoin/ShellCoin.conf
RUN chown -R ShellCoin:ShellCoin /ShellCoin/.ShellCoin

USER ShellCoin
ENV HOME /ShellCoin
WORKDIR /ShellCoin

RUN mkdir /ShellCoin/data
VOLUME /ShellCoin/data

EXPOSE 31100 31000

ENV RPCUSER user
ENV RPCPASS pass

CMD ["ShellCoind"]

