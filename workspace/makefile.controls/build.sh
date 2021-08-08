#!/bin/bash

# defined in makefile
# path to local project directory
echo WORKSPACE IS $workspace


ws_mount="/opt/foster"

# trigger.sh
#
# This script creates a bootstrap build environment for Foster
# It makes a Docker container for the build process (run manually in container)

# The name of the base image we will create
IMAGE_NAME="c-variant"

# We want to orchestrate the docker activity as this is not a web application
# hosting model, we're just using docker for environment boundary
function orchestrate_docker 
{
	# Remove old container
	docker image rm "${IMAGE_NAME}" 2>/dev/null
	
	# Rebuild the base Docker image
	docker build --no-cache -t "${IMAGE_NAME}" $workspace/

	# Run the build container and map /foster_workspace as a volume
	docker run \
		--cpus $(nproc) \
		--rm \
		-h "${IMAGE_NAME}" \
		--memory-swappiness=0 \
		-m $(free -m | grep Mem | awk '{ print $4; }')m \
		--privileged \
		-ti \
		-v $(realpath $workspace):${ws_mount}:Z \
		--name "${IMAGE_NAME}" \
		-d ${IMAGE_NAME}:latest

	# Execute the init script
	docker exec -it "${IMAGE_NAME}" /opt/foster/init.sh

	# Stop the container
	docker stop ${IMAGE_NAME}

	# delete the container
	docker rm ${IMAGE_NAME}	
}

# We'll want to share a host directory with the container as the work inside our
# docker container is to produce artifacts and logs that we want to  analyze 
# outside of the execution context
orchestrate_docker
