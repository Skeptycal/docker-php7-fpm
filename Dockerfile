FROM babim/ubuntubase

MAINTAINER "Duc Anh Babim" <ducanh.babim@yahoo.com>

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install software-properties-common -yq && add-apt-repository ppa:ondrej/php-7.0 && \
    apt-get update && apt-get install -y --force-yes \
    php7.0-cgi php7.0-cli php7.0-phpdbg php7.0-fpm libphp7.0-embed php7.0-dev php7.0-dbg php7.0-curl php7.0-gd php7.0-imap \
    php7.0-interbase php7.0-intl php7.0-ldap php7.0-mcrypt php7.0-readline php7.0-odbc php7.0-pgsql php7.0-pspell php7.0-recode \
    php7.0-tidy php7.0-xmlrpc php7.0 php7.0-json php-all-dev php7.0-sybase php7.0-modules-source php7.0-sqlite3 php7.0-mysql \
    php7.0-opcache php7.0-bz2

RUN sed -ri 's/^display_errors\s*=\s*Off/display_errors = On/g' /etc/php/7.0/fpm/php.ini && \
    sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Asia\/Ho_Chi_Minh/g' /etc/php/7.0/fpm/php.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini && \
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 520M/" /etc/php/7.0/fpm/php.ini && \
    sed -i "s/;opcache.enable=0/opcache.enable=0/" /etc/php/7.0/fpm/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.0/fpm/php-fpm.conf && \
    sed -i '/^listen = /clisten = 9000' /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i '/^listen.allowed_clients/c;listen.allowed_clients =' /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i '/^;catch_workers_output/ccatch_workers_output = yes' /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i '/^;env\[TEMP\] = .*/aenv[DB_PORT_3306_TCP_ADDR] = $DB_PORT_3306_TCP_ADDR' /etc/php/7.0/fpm/pool.d/www.conf
    
RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /build && \
    rm -rf /tmp/* /var/tmp/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /etc/dpkg/dpkg.cfg.d/02apt-speedup

RUN mkdir -p /var/www
VOLUME ["/var/www"]

# Define working directory.
WORKDIR /etc/php7.0/fpm

ENV PHP_FPM_USER=www-data
ENV LC_ALL en_US.UTF-8
ENV TZ Asia/Ho_Chi_Minh

ENTRYPOINT ["/usr/sbin/php7.0-fpm", "-F"]

EXPOSE 9000
