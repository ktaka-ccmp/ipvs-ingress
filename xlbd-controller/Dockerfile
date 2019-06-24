From debian
MAINTAINER Kimitoshi Takahashi <ktaka@ccmp.jp>
#RUN apt-get update && apt-get install ssl-cert apt-utils ipvsadm kmod keepalived iptables procps -y
RUN apt-get update && apt-get install libyaml-dev apt-utils procps -y
RUN mkdir -p /etc/xlbd
RUN mkdir -p /XlbBinary
COPY xlbd.conf.tmpl /
COPY xlbd.conf /etc/xlbd/
COPY xlbd-controller /
COPY XlbBinary/xlb /XlbBinary/
COPY XlbBinary/xlb_cmdline /XlbBinary/
COPY XlbBinary/xlb_kern.ll /XlbBinary/
COPY XlbBinary/xlbd /
#ENTRYPOINT ["/server"]
COPY xlbd.sh /
ENTRYPOINT ["/xlbd.sh"]

