FROM jenkins/jenkins:lts-jdk11

# Disable setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Configuration as code env path
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml

USER root

# Installing docker cli
RUN apt-get update && apt-get install -y apt-transport-https \
       ca-certificates curl gnupg2 \
       software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) stable"
RUN apt-get install -y software-properties-common 
RUN apt-get update
RUN apt-get install -y ansible
RUN apt-get install -y --no-install-recommends docker-ce-cli containerd.io
RUN rm -rf /var/lib/apt/lists/*

# Installing latest docker-compose
ENV DCREPO="docker/compose"
RUN export LATEST_DOCKER_COMPOSE=$(curl --silent "https://api.github.com/repos/${DCREPO}/releases/latest" \
| grep '"tag_name":' \
| sed -E 's/.*"([^"]+)".*/\1/'); \
curl -L "https://github.com/docker/compose/releases/download/${LATEST_DOCKER_COMPOSE}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose;
RUN chmod +x /usr/local/bin/docker-compose
RUN ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

USER jenkins

# Installing plugins
COPY --chown=jenkins:jenkins plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

# Pasing configuration as code to the jenkins server
COPY --chown=jenkins:jenkins casc.yaml /var/jenkins_home/casc.yaml
