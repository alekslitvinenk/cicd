
.PHONY: all build build-local build-edge test clean

all: build

build-local:
	docker build --progress=plain -t alekslitvinenk/cicd-pipeline:local -t alekslitvinenk/cicd-pipeline:latest --no-cache .

build-edge:
	docker build -t alekslitvinenk/cicd-pipeline:edge10 --no-cache .
	docker push alekslitvinenk/cicd-pipeline:edge10

build: build-local
	docker push alekslitvinenk/cicd-pipeline:latest

test: build-local
	docker run --privileged \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v ${PWD}/test-repos:/opt/cicd/repos \
	-v ${PWD}/sslfiles:/opt/cicd/sslfiles \
	-v ${PWD}/reports:/opt/cicd/reports \
	-e DOCKER_USER=alekslitvinenk \
	-e DOCKER_PASSWORD=Ichufef@17 \
	-p 80:3000 \
	-p 443:3443 \
	--name cicd-test \
	--rm \
	alekslitvinenk/cicd-pipeline:local &
	sleep 10
	docker stop cicd-test
	# test badges and http endpoints

clean:
	rm -rf target
	rm -rf reports