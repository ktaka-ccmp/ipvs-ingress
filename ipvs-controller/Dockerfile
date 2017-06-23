From debian
MAINTAINER Kimitoshi Takahashi <ktaka@ccmp.jp>
RUN apt-get update && apt-get install ssl-cert apt-utils ipvsadm kmod keepalived iptables procps -y
RUN mkdir -p /etc/keepalived/ipvs.d
COPY ipvs.conf.tmpl /
COPY ipvs.conf /etc/keepalived/
COPY server /
#ENTRYPOINT ["/server"]
COPY server.sh /
ENTRYPOINT ["/server.sh"]

