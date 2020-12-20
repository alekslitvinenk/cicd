.PHONY: all build build-local build-edge build-branch test

all: build

build-local:
	docker build -t alekslitvinenk/cicd-pipeline:latest --no-cache .

build-edge:
	docker build -t alekslitvinenk/cicd-pipeline:edge --no-cache .
	docker push alekslitvinenk/cicd-pipeline:edge

# TODO: Rewrite to append baranch name as a docker tag
build-edge2:
	docker build -t alekslitvinenk/cicd-pipeline:edge2 --no-cache .
	#docker push alekslitvinenk/cicd-pipeline:edge2

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