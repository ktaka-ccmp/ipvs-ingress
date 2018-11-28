From debian
MAINTAINER Kimitoshi Takahashi <ktaka@ccmp.jp>
RUN apt-get update && apt-get install exabgp -y 
COPY exabgp.sh /
COPY prestop.sh /
ENTRYPOINT ["/exabgp.sh"]

