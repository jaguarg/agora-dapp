# Starting from a base image supported by SCONE  
FROM node:14-alpine3.11

RUN node --version
# install your dependencies
RUN mkdir /app && cd /app

COPY ./app.js /app
COPY ./MiniPoolConfig.js /app
COPY ./package.json /app
COPY ./chain.json /app
COPY ./test.sh /app
RUN cd /app && npm install --force && ls -la
COPY ./libs-node14-compatibility/ /app/node_modules/
RUN cd /app && ./test.sh
ENTRYPOINT [ "node", "/app/app.js"]