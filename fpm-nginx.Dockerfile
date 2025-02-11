FROM liushoukun/php-fpm-nginx:8.3.16

ARG APP_CODE_PATH=../

# install application dependencies
WORKDIR /var/www/app
COPY ${APP_CODE_PATH}composer.json ${APP_CODE_PATH}composer.lock* ./
#RUN composer install --no-scripts --no-autoloader --ansi --no-interaction --no-dev -vvv

# copy php config files
COPY /docker/php-fpm/opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY /docker/php-fpm/laravel.ini /usr/local/etc/php/conf.d
COPY /docker/php-fpm/xlaravel.pool.conf /usr/local/etc/php-fpm.d/

# copy nginx configuration
COPY /docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY /docker/nginx/sites /etc/nginx/conf.d
COPY /docker/nginx/ssl /etc/nginx/ssl

# copy application code
WORKDIR /var/www/app
COPY ${APP_CODE_PATH} .
RUN composer dump-autoload -o \
    && chown -R :www-data /var/www/app \
    && chmod -R 775 /var/www/app/storage /var/www/app/bootstrap/cache


###########################################################################
# Supervisord
###########################################################################


COPY /docker/supervisord/supervisord.conf /etc/supervisord.conf
COPY /docker/supervisord/conf/*  /etc/supervisord/


###########################################################################
# Crontab
###########################################################################

COPY /docker/crontab /etc/crontabs
#
RUN chmod -R 644 /etc/crontabs


#  初始化脚本

ADD /docker/startup.sh /opt/startup.sh
RUN sed -i 's/\r//g' /opt/startup.sh

EXPOSE 80 443

CMD ["/bin/sh","/opt/startup.sh"]