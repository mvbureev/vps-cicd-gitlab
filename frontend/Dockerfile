FROM node:alpine

WORKDIR /usr/app

RUN yarn add global pm2

COPY ./package*.json ./

RUN yarn --production

COPY ./ ./

RUN yarn build

EXPOSE 3000

USER node

CMD [ "pm2-runtime", "start", "yarn", "--", "start" ]
