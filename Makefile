IMAGE = fopina/swarm-service-proxy
VERSION = 6

build:
	docker build -t ${IMAGE}:test \
				 .
release:
	docker buildx build \
           --platform linux/amd64,linux/arm64 \
           --build-arg VERSION=${VERSION} \
           --push \
           -t ${IMAGE}:${VERSION} \
           -t ${IMAGE}:latest \
           .

test: build
	docker run --rm \
	           -ti \
			   -v /var/run/docker.sock:/var/run/docker.sock \
			   -p 9999:80 \
			   -e PROXIED_PORT=80 \
			   -e PROXIED_IMAGE=nginx:1.17 \
			   -e PROXIED_FLAGS="-e A='test env with spaces'" \
			   ${IMAGE}:test

test-udp: build
	docker run --rm \
	           -ti \
			   -v /var/run/docker.sock:/var/run/docker.sock \
			   -p 53:53/udp \
			   -e PROXIED_PORT=53 \
			   -e PROXIED_PROTO=udp \
			   -e PROXIED_IMAGE=gists/dnsmasq \
			   ${IMAGE}:test

docker-version: build
	docker run --rm \
	           -ti \
			   -v /var/run/docker.sock:/var/run/docker.sock \
			   --entrypoint '' \
			   ${IMAGE}:test \
			   docker version
