From debian
MAINTAINER Kimitoshi Takahashi <ktaka@ccmp.jp>
RUN apt-get update && apt-get install ssl-cert apt-utils ipvsadm kmod -y
COPY server /
ENTRYPOINT ["/server"]

