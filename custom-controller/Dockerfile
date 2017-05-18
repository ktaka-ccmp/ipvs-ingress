From debian
MAINTAINER Kimitoshi Takahashi <ktaka@ccmp.jp>
RUN apt-get update && apt-get install ssl-cert apt-utils -y
COPY server /
ENTRYPOINT ["/server"]

