---
title: Konfiguracja środowiska deweloperskiego PHP z nginx w Ubuntu 10.04
slug: konfiguracja-srodowiska-deweloperskiego-php-z-nginx-w-ubuntu-1004
author: Jakub Zalas
description: 
post_id: 556
created: 2010/03/28 22:10:32
created_gmt: 2010/03/28 21:10:32
comment_status: open
post_name: konfiguracja-srodowiska-deweloperskiego-php-z-nginx-w-ubuntu-1004
status: publish
post_type: post
---

<!--Nginx to lekki serwer http i proxy. Potrafi także działać jako load balancer. Stanowi poważną alternatywę dla przeładowanego apache. W środowisku prodykcyjnym nginx zaskakuje wydajnością oraz małym zużyciem pamięci. W warunkach deweloperskich cenię jego prostą i elastyczną konfigurację. Oto opis jak szybko przygotować środowisko deweloperskie PHP z nginx w Ubuntu 10.04 (Lucid Lynx).-->

# Konfiguracja środowiska deweloperskiego PHP z nginx w Ubuntu 10.04

![Nginx Logo](/uploads/wp/2010/03/nginx-logo.png)[Nginx](http://wiki.nginx.org/) to lekki serwer http i proxy. Potrafi także działać jako load balancer. Stanowi poważną **alternatywę** dla przeładowanego **apache**. W środowisku prodykcyjnym nginx zaskakuje **wydajnością** oraz małym zużyciem **pamięci**. W warunkach deweloperskich cenię jego prostą i elastyczną **konfigurację**. Oto opis jak szybko przygotować **środowisko deweloperskie PHP** z **nginx** w **Ubuntu** 10.04 (Lucid Lynx). **Uwaga**: Uaktualniona wersja tego artukułu znajduje się tutaj: "[Konfiguracja środowiska deweloperskiego PHP z nginx w Ubuntu 11.04](/konfiguracja-srodowiska-deweloperskiego-php-z-nginx-w-ubuntu-1104)". 

## PHP

Instalujemy pakiety i moduły PHP: 
    
    
    sudo aptitude install php5-cgi php5-cli php5-common php5-curl php5-gd \
      php5-imagick php5-json php5-mcrypt php5-mysql php5-pgsql php5-sqlite \
      php5-xmlrpc php5-xsl php5-xdebug php-apc

## Spawn FCGI

Instalujemy skrypt spawn-fcgi: 
    
    
    sudo aptitude install spawn-fcgi

Zapisujemy [skrypt startujący instancje php-cgi](http://github.com/jakzal/php-cgi/raw/master/etc/init.d/php-cgi) jako _/etc/init.d/php-cgi_: 
    
    
    #! /bin/sh
    
    ### BEGIN INIT INFO
    # Provides:          php-cgi
    # Required-Start:    $local_fs $remote_fs $network $syslog
    # Required-Stop:     $local_fs $remote_fs $network $syslog
    # Default-Start:     2 3 4 5
    # Default-Stop:      0 1 6
    # Short-Description: spawns the php-cgi
    # Description:       spawns the php-cgi
    ### END INIT INFO
    
    PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
    NAME=php-cgi
    DESC=php-cgi
    
    test -x $DAEMON || exit 0
    
    PIDFILE="/var/run/$NAME.pid"
    DAEMON="/usr/bin/php-cgi"
    SPAWN_FCGI="/usr/bin/spawn-fcgi"
    FCGI_PORT=9000
    FCGI_USER="www-data"
    FCGI_GROUP="www-data"
    FCGI_CHILDREN=0
    
    # Include php-cgi defaults if available
    if [ -f /etc/default/php-cgi ] ; then
            . /etc/default/php-cgi
    fi
    
    SPAWN_FCGI_OPTS="-f $DAEMON -a 127.0.0.1 -p $FCGI_PORT -u $FCGI_USER -g $FCGI_GROUP -C $FCGI_CHILDREN -P $PIDFILE"
    
    set -e
    
    . /lib/lsb/init-functions
    
    case "$1" in
      start)
            echo -n "Starting $DESC: "
            start-stop-daemon --start --quiet --pidfile $PIDFILE --exec "$SPAWN_FCGI" -- $SPAWN_FCGI_OPTS || true
            echo "$NAME."
            ;;
      stop)
            echo -n "Stopping $DESC: "
            start-stop-daemon --stop --quiet --pidfile $PIDFILE --exec "$DAEMON" || true
            echo "$NAME."
            ;;
      restart)
            echo -n "Restarting $DESC: "
            start-stop-daemon --stop --quiet --pidfile $PIDFILE --exec "$DAEMON" || true
            sleep 1
            start-stop-daemon --start --quiet --pidfile $PIDFILE --exec "$SPAWN_FCGI" -- $SPAWN_FCGI_OPTS || true
            echo "$NAME."
            ;;
      status)
            status_of_proc -p $PIDFILE "$DAEMON" php-cgi && exit 0 || exit $?
            ;;
      *)
            echo "Usage: $NAME {start|stop|restart|status}" >&2
            exit 1
            ;;
    esac
    
    exit 0

Nadajemy mu prawa do uruchamiania: 
    
    
    sudo chmod +x /etc/init.d/php-cgi

Umieszczamy [konfigurację](http://github.com/jakzal/php-cgi/raw/master/etc/default/php-cgi) w _/etc/default/php-cgi_: 
    
    
    PIDFILE="/var/run/php-cgi.pid"
    DAEMON="/usr/bin/php-cgi"
    SPAWN_FCGI="/usr/bin/spawn-fcgi"
    FCGI_PORT=9000
    FCGI_USER="www-data"
    FCGI_GROUP="www-data"
    FCGI_CHILDREN=0

**Uwaga**: Moje najbardziej aktualne skrypty startowe dostępne są na githubie: <http://github.com/jakzal/php-cgi>. 

## Nginx

Instalujemy nginx: 
    
    
    sudo aptitude install nginx

Zapisujemy konfigurację domen _*.dev_ do pliku _/etc/nginx/sites-available/dev.conf_: 
    
    
    server {
      listen 80;
      server_name *.dev;
      root /var/www/$host/web;
    
      access_log /var/log/nginx/$host.access.log;
      error_log /var/log/nginx/error.log error;
    
      location / {
        root   /var/www/$host/web/;
        index  index.php;
    
        # serve static files directly
        if (-f $request_filename) {
          access_log        off;
          expires           30d;
          break;
        }
    
        rewrite ^(.*) /index.php last;
      }
    
      location ~ \.php {
        fastcgi_index  index.php;
    
        set  $script     $uri;
        set  $path_info  "";
        if ($uri ~ "^(.+\.php)(/.*)") {
          set  $script     $1;
          set  $path_info  $2;
        }
        fastcgi_pass   127.0.0.1:9000;
        include /etc/nginx/fastcgi_params;
        fastcgi_param  SCRIPT_FILENAME  /var/www/$host/web$script;
        fastcgi_param  PATH_INFO        $path_info;
        fastcgi_param  SCRIPT_NAME $script;
      }
    
      location ~ /\.ht {
        deny  all;
      }
    }

Czynimy konfigurację widoczną dla nginx: 
    
    
    sudo ln -s /etc/nginx/sites-available/dev.conf /etc/nginx/sites-enabled/dev.conf

## Konfiguracja systemu

Dodajemy siebie do grupy _www-data_ i logujemy ponownie: 
    
    
    sudo usermod -a -G www-data kuba
    sudo su kuba

Pozwalamy, aby wszyscy należący do grupy _www-data_ mogli tworzyć strony: 
    
    
    sudo chown -R www-data:www-data /var/www
    sudo chmod -R 775 /var/www

Definiujemy fikcyjne poddomeny *.dev w _/etc/hosts _(dużo wygodniej jest użyć [dnsmasq](http://http://www.thekelleys.org.uk/dnsmasq/doc.html), ale na początek plik hosts powinien być wystarczający): 
    
    
    127.0.0.1 localhost info.dev myproject.dev

Tworzymy stronę testową: 
    
    
    mkdir /var/www/info.dev/web -p
    echo "<?php echo phpinfo(); ?>" > /var/www/info.dev/web/index.php
    chown -R :www-data /var/www/info.dev
    chmod -R 775 /var/www/info.dev

Uruchamiamy php-cgi i nginx: 
    
    
    sudo service php-cgi start
    sudo service nginx start

W końcu odwiedzamy http://info.dev w przeglądarce internetowej i cieszymy się widokiem skonfigurowanego PHP z nginx.

## Comments

**[iczek](#3006 "2010-08-16 10:28:48"):** Chciałbym się dowiedzieć, co robi ten fragment w pliku konfiguracyjnym domeny dev.conf:"rewrite ^(.*) /index.php last;"Bo uniemożliwia mi dostanie się do podkatalogów, np. nie wyświetla /wp-admin, nginx odrzuca żądanie i przekierowuje do /index.php. Tego fragmentu też nie ma w innych konfiguracjach, które znalazłem na sieci.

**[Kuba](#3007 "2010-08-16 13:28:41"):** @iczek ten fragment przepisuje wszystko do index.php, aby działały mi "ładne URLe" w stylu "/artykuly/o-nas". Przykładowo http://strona.dev/artykuly/o-nas będzie równoważne z http://strona.dev/index.php/artykuly/o-nas.

**[iczek](#3008 "2010-08-17 02:46:23"):** Właśnie chodzi o to, że powoduje to efekt opisany przeze mnie. Zainstalowałem w maszynie wirtualnej pod Windowsem Ubuntu 10.04 i próbowałem zaistalować przy tej konfiguracji Wordpress 3. Po zalogowaniu w okienku logowania do panelu admina wywala mnie zamiast do Kokpitu na stronę główną (czyli przekierowało mnie na /indeh.php) i nie pozwala dostać się do /wp-admin. Po zahaszowaniu tego fragmentu konfiguracji wszystko działa jak należy.

**[Kuba](#3009 "2010-08-17 11:32:40"):** @iczek to zrozumiałe, bo wszystko jest przepisywane na index.php. Mój opis skupia się na konfiguracji php+nginx, a nie na szczegółach nginx. Przedstawiona konfiguracja jest przykładowa, można powiedzieć wyjściowa. Niestety nginx nie dysponuje mechanizmem typu htaccess znanym z apache i więcej trzeba robić na poziomie głównego pliku konfiguracyjnego. Ja zwykle działam z kilkoma kontrolerami w katalogu głównym, stad takie a nie inne domyślne zestawienie. Do Twoich potrzeb musisz dostosować nieco plik konfiguracyjny nginx (tym bardziej dla WordPressa). W necie jest wiele przykładów, ale może to dobry temat na kolejny wpis :) Dzięki za zaintersowanie!

**[xis](#3017 "2011-02-08 01:59:08"):** Dzięki za tip z "server_name *.dev;" i $host w nginx! Nie miałem o tym pojęcia wcześniej i tworzyłem dla każdego projektu nowy plik w sites-available :)

**[Kuba](#3018 "2011-02-09 07:53:47"):** @xis te opcje nie zawsze były dostępne. Warto śledzić zmiany w nginx, bo aktywnie się rozwija ;)

