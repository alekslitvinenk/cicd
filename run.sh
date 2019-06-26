#!/usr/bin/env bash
# -v /var/run/docker.sock:/var/run/docker.sock  to map inner docker daemon to the outer one
docker run --privileged -v /var/run/docker.sock:/var/run/docker.sock -it alekslitvinenk/cicd-pipeline