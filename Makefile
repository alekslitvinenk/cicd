
.PHONY: all build build-local build-edge test clean

all: build

build-local:
	docker build --progress=plain -t alekslitvinenk/cicd-pipeline:local -t alekslitvinenk/cicd-pipeline:latest --no-cache .

build-edge:
	docker build -t alekslitvinenk/cicd-pipeline:edge13 --no-cache .
	docker push alekslitvinenk/cicd-pipeline:edge13

build: build-local
	docker push alekslitvinenk/cicd-pipeline:latest

test:
	docker run --privileged \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-e DOCKER_USER=alekslitvinenk \
	-e DOCKER_PASSWORD=Ichufef@17 \
	-e START_HTTPS_SERVER=false \
	-p 80:3000 \
	-p 443:3443 \
	--name cicd-test \
	--rm \
	alekslitvinenk/cicd-pipeline:latest &
	sleep 10
	docker stop cicd-test
	# test badges and http endpoints

clean:
	rm -rf target
	rm -rf reports