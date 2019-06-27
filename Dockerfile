FROM sonarqube

VOLUME /opt/sonarqube/conf
VOLUME /opt/sonarqube/data
VOLUME /opt/sonarqube/extensions

EXPOSE 9000
