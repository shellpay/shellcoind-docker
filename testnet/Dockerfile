FROM ShellCoind:v1

EXPOSE 44555 44556

USER root
ADD ShellCoin.conf /ShellCoin/.ShellCoin/ShellCoin.conf
RUN chown -R ShellCoin:ShellCoin /ShellCoin/.ShellCoin
USER ShellCoin

