
#GlassFish Server Open Source Edition 3.1.2 (build 23)
#-----------------------------RECORDAR CREAR LAS VARIABLES DE ENTORNO--------------
##AS_ADMIN_PASSWORD  Gla$fish2020
#AS_ADMIN_ENABLE_SECURE
#100GB /home/Digitalizados
#10GB /usr/local/glassfish3
FROM openjdk:7u151-jdk-alpine

# Set environment variables
ENV GLASSFISH_PKG=/tmp/glassfish-3.1.2.2.zip \
    GLASSFISH_URL=http://download.oracle.com/glassfish/3.1.2.2/release/glassfish-3.1.2.2.zip \
    GLASSFISH_HOME=/usr/local/glassfish3 \
    MD5=ae8e17e9dcc80117cb4b39284302763f \
    PATH=$PATH:/usr/local/glassfish3/bin

# Download and install GlassFish
RUN wget -q -O $GLASSFISH_PKG $GLASSFISH_URL && \
    echo "$MD5 *$GLASSFISH_PKG" | md5sum -c - && \
    unzip -o $GLASSFISH_PKG -d /usr/local && \
    rm -f $GLASSFISH_PKG && \
    \
    # Remove Windows .bat and .exe files to save space
    cd $GLASSFISH_HOME && \
    find . -name '*.bat' -delete && \
    find . -name '*.exe' -delete


# Ports being exposed
EXPOSE 4848 8080 8181



# Copy in and set the entrypoint
COPY docker-entrypoint.sh /usr/local/glassfish3

RUN chgrp -R 0 /usr/local/glassfish3/docker-entrypoint.sh && \
    chmod -R g=u /usr/local/glassfish3/docker-entrypoint.sh
#COPY /docker-entrypoint.sh $GLASSFISH_HOME/
RUN chmod 777 /usr/local/glassfish3/docker-entrypoint.sh
RUN chgrp -R 0 /usr/local/glassfish3 && \
    chmod -R g=u /usr/local/glassfish3
    
    RUN chmod g=u /etc/passwd
  #/usr/local/glassfish3

RUN mkdir  /home/digitalizados
RUN chmod 777 /home/digitalizados
VOLUME ["/home/digitalizados"]
RUN cp -rf  /usr/local/glassfish3/* /home/digitalizados

VOLUME  ["/usr/local/glassfish3"]
WORKDIR /usr/local/glassfish3
ENTRYPOINT ["/usr/local/glassfish3/docker-entrypoint.sh"]

USER 1001
# Start the GlassFish domain
CMD ["asadmin", "start-domain", "--verbose"]

LABEL maintainer=" <josue.ramrez>" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.name="GlassFish" \
      org.label-schema.version="3.1.2.2" \
      org.label-schema.url="https://glassfish.java.net" \
      org.label-schema.vcs-url="https://github.com/Eliseo247/infosweb-glassfish3.1-openjdk7"
