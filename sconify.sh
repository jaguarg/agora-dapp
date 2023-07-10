#!/bin/bash

# declare the app entrypoint
#ENTRYPOINT="node /src/app.js"
ENTRYPOINT='"node -v && cat /app/node_modules/@iexec/dataprotector/dist/services/ipfs.js"'
# declare an image name
IMG_NAME=minipool
VER="0.1.4" 
IMG_FROM=${IMG_NAME}:${VER}-temp-non-tee
IMG_TO=${IMG_NAME}:${VER}-tee-debug

# build the regular non-TEE image
docker build . -t ${IMG_FROM} --no-cache --progress=plain

# pull the SCONE curated image corresponding to our base image
docker pull registry.scontain.com:5050/sconecuratedimages/node:14.4.0-alpine3.11

# run the sconifier to build the TEE image based on the non-TEE image
docker run -it --rm \
            -v /var/run/docker.sock:/var/run/docker.sock \
            registry.scontain.com:5050/scone-production/iexec-sconify-image:5.7.5-v8 \
            sconify_iexec \
            --name=${IMG_NAME} \
            --from=${IMG_FROM} \
            --to=${IMG_TO} \
            --binary-fs \
            --fs-dir=/app \
            --host-path=/etc/hosts \
            --host-path=/etc/resolv.conf \
            --binary=/usr/local/bin/node \
            --heap=1G \
            --dlopen=1 \
            --no-color \
            --verbose \
            --command=${ENTRYPOINT} \
            && echo -e "\n------------------\n" \
            && echo "successfully built TEE docker image => ${IMG_TO}" \
            && echo "application mrenclave.fingerprint is $(docker run -it --rm -e SCONE_HASH=1 ${IMG_TO})"