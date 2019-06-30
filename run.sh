#!/usr/bin/env bash
# -v /var/run/docker.sock:/var/run/docker.sock  to map inner docker daemon to the outer one
# -v /opt/cicd/repos:/opt/cicd/repos
docker run --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /Users/alitvinenko/repos:/opt/cicd/repos \
-e DOCKER_USER="alekslitvinenk" \
-e DOCKER_PASSWORD="jobjob@3" \
-it alekslitvinenk/cicd-pipeline