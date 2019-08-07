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

COPY snmpd.conf /etc/snmp/snmpd.conf
RUN sed -e 's|<SNMPD_HOST>|$SNMPD_HOST|g' -i /etc/snmp/snmpd.conf
RUN sed -e 's|<SNMPD_COMMUNITY>|$SNMPD_COMMUNITY|g' -i /etc/snmp/snmpd.conf

COPY test.sh /test.sh
COPY updater.sh /updater.sh
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
#CMD [ "exit" ]

# END
