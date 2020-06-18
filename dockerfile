FROM ubuntu:bionic-20200526

ENV HAPROXY_USER haproxy

COPY ./haproxy-2.0.15 /

RUN apt update && apt install -y git ca-certificates gcc libc6-dev liblua5.3-dev libpcre3-dev libssl-dev libsystemd-dev make wget zlib1g-dev
RUN make TARGET=linux-glibc USE_LUA=1 USE_OPENSSL=1 USE_PCRE=1 USE_ZLIB=1 USE_SYSTEMD=1 EXTRA_OBJS="contrib/prometheus-exporter/service-prometheus.o"
RUN make install
RUN groupadd --system ${HAPROXY_USER} && \
  useradd --system --gid ${HAPROXY_USER} ${HAPROXY_USER} && \
  mkdir --parents /var/lib/${HAPROXY_USER} && \
  chown -R ${HAPROXY_USER}:${HAPROXY_USER} /var/lib/${HAPROXY_USER}

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["haproxy", "-db", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]