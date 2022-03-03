# Jenkins server in a docker container

Basic Jenkins server with default plugins installed. The list of the plugins is stored in [plugins.txt](plugins.txt) and can be modifed to add/remove packages.


A [.env](.env) file is <b>required</b> with these values inside: 
```
JENKINS_HOSTNAME=localhost
JENKINS_PORT=8080
JENKINS_ADMIN_ID=admin
JENKINS_ADMIN_PASSWORD=password
```

We use the Configuration as Code plugin to configure Jenkins based on a basic [casc.yaml](casc.yaml) file (_a human-readable declarative configuration file_). More information about the plugin [jcasc-plugin](https://github.com/jenkinsci/configuration-as-code-plugin#jenkins-configuration-as-code-aka-jcasc-plugin).

The provided [casc.yaml](casc.yaml) includes basic configuration such as: 
- The **url** of the jenkins server.
- A disabled signup process.
- A template for the user and password; configurable in the [.env](.env) file.
- An *authorization strategy* setting up global Administer and Read permisions for the specified user in the [.env](.env) file.
- A build authorization strategy; all jobs configured or triggered can be run just by the Jenkins user that created them.
- Enabling Agent to Controller Access Control

To run this Jenkins server:

```bash
# Clone the repo
git clone https://github.com/cduran/jenkins-dind-docker-compose.git

# Move into the folder
cd jenkins-dind-docker-compose

# Create .env file
touch .env

# Add variables to the .env file
echo "JENKINS_HOSTNAME=localhost" >> .env
echo "JENKINS_PORT=8080" >> .env
echo "JENKINS_ADMIN_ID=admin" >> .env
echo "JENKINS_ADMIN_PASSWORD=password" >> .env

# run docker-compose to build and run jenkins in background
docker compose up --build -d
```
Jenkins server now accessible here `http://localhost:8080` (_as per [.env](.env) values._)

Note:
This build uses the Docker in Docker `docker:dind` image
