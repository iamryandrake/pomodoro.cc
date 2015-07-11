FROM nginx:1.9.1
RUN ["rm", "/etc/nginx/nginx.conf"]
ADD etc/nginx/nginx.conf /etc/nginx/nginx.conf
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log
EXPOSE 80
