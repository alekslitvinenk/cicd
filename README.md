![Build Status](http://cicd.dockovpn.io/version/cicd)
![Build Status](http://cicd.dockovpn.io/build/cicd)
![Build Time](http://cicd.dockovpn.io/built/cicd)
[![Docker Pulls](https://img.shields.io/docker/pulls/alekslitvinenk/cicd-pipeline.svg)](https://hub.docker.com/r/alekslitvinenk/cicd-pipeline/)
![GitHub](https://img.shields.io/github/license/alekslitvinenk/cicd)

# 📦 CICD Pipeline

A simple tool for build/test automation.

# Quick Start 🚀

1. Create a directory called `repos` in your server. For the sake of convenience we recommend to do so in the `/opt/cicd` path:
```
cd /opt
mkdir -p cicd/repos
```
2. Go to the newly cretaed directory:
```
cd cicd/repos
```
3. Clone the repos you want to automate the building/testing process of:
```
git clone <https path to your repo>
```
ℹ️ **Note:** CICD Pipeline doesn't wirk with `git` protocol at the time.

4. Run docker:
```
docker run --privileged \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /opt/cicd/repos:/opt/cicd/repos \
-v /opt/cicd/sslfiles:/opt/cicd/sslfiles \
-e DOCKER_USER=<your docker login> \
-e DOCKER_PASSWORD=<your docker password> \
-p 80:3000 \
-p 443:3443 \
-it alekslitvinenk/cicd-pipeline
```
ℹ️ **Note:** This configuration is tailored for building and publishing docker images to Docker Hub.<br>
For that reason it has some tweaks:
1. `-v /var/run/docker.sock:/var/run/docker.sock` - binds inner docker unxi socket to the outer one.
2. Sets two environment variables to run `docker login`.
3. `--privileged` flag is required since cicd-pipeline runs docker-in-docker configuration.
