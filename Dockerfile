FROM openjdk-8-rhel8:latest


ENV GLASSFISH_HOME /usr/local/glassfish4
ENV PATH $PATH:$JAVA_HOME/bin:$GLASSFISH_HOME/bin




EXPOSE 4848 8080 8181 9009

WORKDIR /usr/local/glassfish4

CMD  asadmin start-domain --verbose
