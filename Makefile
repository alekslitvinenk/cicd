.PHONY: all build build-local test

all: build

build-local:
	docker build -t alekslitvinenk/cicd-pipeline:latest --no-cache .

build: build-local
	docker push alekslitvinenk/cicd-pipeline:latest

test:
	docker run --privileged \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v ${PWD}/test-repos:/opt/cicd/repos \
	-v ${PWD}/sslforfree:/opt/cicd/sslfiles \
	-e DOCKER_USER=alekslitvinenk \
	-e DOCKER_PASSWORD=Ichufef@17 \
	-p 80:3000 \
	-p 443:3443 \
	--name cicd-test \
	alekslitvinenk/cicd-pipeline &
	sleep 10
	docker stop cicd-test
	docker rm cicd-test