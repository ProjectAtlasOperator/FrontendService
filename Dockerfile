# build environment
FROM node:14 as builder
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
ENV PATH /usr/src/app/node_modules/.bin:$PATH
COPY package.json /usr/src/app/package.json
RUN npm install --silent
COPY . /usr/src/app
RUN npm run build

# production environment
FROM nginx:1.21.0-alpine
COPY --from=builder /usr/src/app/dist /usr/share/nginx/html
COPY --from=builder /usr/src/app/nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /var/cache/nginx/ \
    && touch /var/run/nginx.pid \
    && chgrp -R 0 /usr/share/nginx/html /etc/nginx/ /var/cache/nginx/ /var/run/nginx.pid \
    && chmod -R g=u /usr/share/nginx/html /etc/nginx/ /var/cache/nginx/ /var/run/nginx.pid
EXPOSE 8080
USER 1001
