# Starting from a base image supported by SCONE  
FROM node:16.13.1-alpine

RUN node --version

RUN apk add g++ make
RUN apk add --no-cache python3 py3-pip

# install your dependencies
RUN mkdir /app && cd /app

COPY ./app.js /app
COPY ./MiniPoolConfig.js /app
COPY ./package.json /app
COPY ./chain.json /app
RUN cd /app && npm install --save --force 
COPY ./libs-node16.13.1-compatibility/ /app/node_modules/
# ENTRYPOINT [ "node", "/app/app.js"]
ENTRYPOINT [ "node", "/app/app.js"]