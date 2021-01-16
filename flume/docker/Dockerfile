FROM bde2020/flume:latest
RUN mkdir -p /var/log/flume
ADD flume-startup.json /config/
ADD twitter.properties /config/
ENTRYPOINT /app/bin/flume-ng agent -Xmx512m -f /config/twitter.properties  -Dflume.root.logger=INFO,console -n twitterAgent --conf /config/