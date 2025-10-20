FROM node:20-alpine

RUN mkdir -p /usr/app

COPY ./app /opt/app

WORKDIR /usr/app

RUN npm install

EXPOSE 3000

CMD [ "node", "server.js" ]