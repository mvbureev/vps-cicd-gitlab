FROM node:alpine

WORKDIR /usr/app

ENV YARN_CACHE_FOLDER=/dev/shm/yarn_cache

RUN yarn add global install pm2

COPY ./package*.json ./

RUN yarn --production --frozen-lockfile

COPY ./ ./

RUN yarn build

EXPOSE 3000

USER node

CMD [ "pm2-runtime", "start", "yarn", "--", "start" ]
