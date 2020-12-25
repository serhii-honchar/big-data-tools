FROM apache/nifi:1.12.1

ENV NIFI_WEB_HTTP_PORT=8080

COPY --chown=nifi:nifi ./store /opt/gl-bigdata-procamp
COPY --chown=nifi:nifi conf/flow.xml.gz-kafka /opt/nifi/nifi-current/conf/flow.xml.gz
