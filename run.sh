#!/usr/bin/env bash
# -v /var/run/docker.sock:/var/run/docker.sock  to map inner docker daemon to the outer one
# -v /opt/cicd/repos:/opt/cicd/repos
docker run --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /opt/cicd/repos:/opt/cicd/repos -it alekslitvinenk/cicd-pipeline