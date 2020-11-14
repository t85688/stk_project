# Dockerfile

FROM python:3.7-buster

# install nginx
RUN apt-get update && apt-get install nginx vim -y --no-install-recommends
COPY nginx.default /etc/nginx/sites-available/default
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# copy source and install dependencies
RUN mkdir -p /opt/django
RUN mkdir -p /opt/django/pip_cache
RUN mkdir -p /opt/django/stk_proj
COPY requirements.txt start-server.sh /opt/django/
COPY .pip_cache /opt/django/pip_cache/
COPY stk_proj /opt/django/stk_proj/
WORKDIR /opt/django
RUN pip install -r requirements.txt --cache-dir /opt/django/pip_cache
RUN chown -R www-data:www-data /opt/django

# start server
EXPOSE 8020
STOPSIGNAL SIGTERM
CMD ["/opt/django/start-server.sh"]