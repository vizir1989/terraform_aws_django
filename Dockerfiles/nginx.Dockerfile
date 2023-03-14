FROM nginx:1.20-alpine

RUN rm /etc/nginx/conf.d/default.conf
COPY ./nginx/nginx.conf /etc/nginx/conf.d
RUN mkdir -p /usr/src/app
EXPOSE 80