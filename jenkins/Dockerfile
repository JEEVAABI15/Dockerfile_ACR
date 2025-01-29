FROM jenkins/jenkins:lts-alpine
USER root
RUN apk update && apk add --no-cache \
    python3 \
    py3-pip \
    curl \
    openjdk11-jdk
COPY jenkins-setup.sh /usr/share/jenkins/jenkins-setup.sh
RUN chmod +x /usr/share/jenkins/*.sh
USER jenkins
EXPOSE 8083 50000
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]
CMD ["/bin/sh", "-c", "sleep 30 && /usr/share/jenkins/jenkins-setup.sh && tail -f /dev/null"]