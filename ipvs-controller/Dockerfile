From debian
MAINTAINER Kimitoshi Takahashi <ktaka@ccmp.jp>
RUN apt-get update && apt-get install ssl-cert apt-utils ipvsadm kmod keepalived iptables procps gettext-base -y
RUN mkdir -p /etc/keepalived/ipvs.d
RUN mkdir -p /var/run/netns
COPY ipvs.conf.tmpl.tmpl /
COPY ipvs.conf /etc/keepalived/
COPY server /
#ENTRYPOINT ["/server"]
COPY server.sh /
COPY prestop.sh /
ENTRYPOINT ["/server.sh"]

