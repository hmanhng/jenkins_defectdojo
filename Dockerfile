FROM jenkins/jenkins:2.504.3-lts-jdk17

USER root

RUN apt-get update && \
    apt-get install -y docker.io ca-certificates curl && \
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV JENKINS_UC=https://updates.jenkins.io
ENV JENKINS_UC_DOWNLOAD=https://updates.jenkins.io/download
ENV JENKINS_PLUGIN_INFO=https://updates.jenkins.io/plugin-versions.json

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN jenkins-plugin-cli \
    --plugin-file /usr/share/jenkins/ref/plugins.txt \
    --latest=false \
    --verbose

USER jenkins
