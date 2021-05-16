FROM node:alpine

WORKDIR /usr/app

ENV YARN_CACHE_FOLDER=/dev/shm/yarn_cache

RUN yarn install --global pm2

COPY ./package*.json ./

RUN yarn install --production --frozen-lockfile

COPY ./ ./

RUN yarn build

EXPOSE 3000

USER node

CMD [ "pm2-runtime", "start", "yarn", "--", "start" ]
