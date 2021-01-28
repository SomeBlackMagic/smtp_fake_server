FROM openjdk:11.0-jre

RUN wget https://github.com/gessnerfl/fake-smtp-server/releases/download/1.7.1/fake-smtp-server-1.7.1.jar  -O /opt/fake-smtp-server.jar
###
### Ports
###
EXPOSE 5080
EXPOSE 5081
EXPOSE 5025

ENV JAVA_OPTS=""

###
### Entrypoint
###
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
RUN mkdir /docker-entrypoint.d
RUN touch /run.sh && chmod +x /run.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/run.sh"]

