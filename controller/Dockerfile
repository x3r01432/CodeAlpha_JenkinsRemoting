FROM jenkins/jenkins:2.580.1-lts-jdk21
# Skip the setup wizard; everything is configured as code
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false" \
    CASC_JENKINS_CONFIG=/var/jenkins_home/casc
COPY --chown=jenkins:jenkins plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt
COPY --chown=jenkins:jenkins casc/ /var/jenkins_home/casc/
COPY --chown=jenkins:jenkins pipelines/ /usr/share/jenkins/ref/pipelines/
COPY --chown=jenkins:jenkins jobs.groovy /usr/share/jenkins/ref/jobs.groovy
USER jenkins
