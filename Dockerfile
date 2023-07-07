FROM node:18.16.1-alpine3.18
### install your dependencies if you have some
RUN mkdir /app && cd /app && npm install figlet@1.x
COPY ./app.js /app
ENTRYPOINT [ "node", "/app/app.js"]