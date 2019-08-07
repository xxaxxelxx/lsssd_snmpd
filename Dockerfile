FROM debian:buster
MAINTAINER xxaxxelxx <x@axxel.net>

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm

RUN apt-get -qq -y update
RUN apt-get -qq -y dist-upgrade

RUN apt-get -qq -y install mc
RUN apt-get install -y mariadb-client
RUN apt-get install -y snmpd
# clean up
RUN apt-get clean

COPY snmpd.conf /snmpd.conf
COPY test.sh /test.sh
COPY ask_mysql.sh /ask_mysql.sh
COPY confupdater.sh /confupdater.sh
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
#CMD [ "exit" ]

# END
