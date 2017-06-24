---
title: Konfiguracja środowiska deweloperskiego PHP z Nginx w Ubuntu 11.04
slug: konfiguracja-srodowiska-deweloperskiego-php-z-nginx-w-ubuntu-1104
author: Jakub Zalas
description: 
post_id: 898
created: 2011/05/05 21:38:02
created_gmt: 2011/05/05 20:38:02
comment_status: open
post_name: konfiguracja-srodowiska-deweloperskiego-php-z-nginx-w-ubuntu-1104
status: publish
layout: post
tags:
- configuration
- installation
- nginx
- php
- ubuntu
expired: true
comments: true
---

![](/uploads/wp/2011/05/nginx-php.png)Opisywałem już [jak przygotować PHP do pracy z Nginx w Ubuntu 10.04](/konfiguracja-srodowiska-deweloperskiego-php-z-nginx-w-ubuntu-1004). W Ubuntu **11.04** (Natty Narwhal) procedura jest dużo prostsza za sprawą **PHP 5.3** i obecnego w nim [php-fpm](http://pl.php.net/manual/en/install.fpm.php). Ponieważ w międzyczasie udało mi się też ulepszyć swoją konfigurację **Nginx** dla PHP, postanowiłem opisać temat jeszcze raz.

## PHP

Na początek instalujemy pakiety i moduły PHP (dobieramy wedle potrzeb): 
    
    
    sudo apt-get install php5-fpm php5-cli php5-common php5-curl php5-gd \
      php5-mcrypt php5-mysql php5-pgsql php5-sqlite php5-tidy php5-xmlrpc \
      php5-xsl php5-intl php5-imagick php5-xdebug php-apc php-pear

Wszystkie pliki konfiguracyjne do PHP i php-fpm znajdziemy w katalogu _/etc/php5/fpm_. Jednak na początek domyślna konfiguracja powinna nam wystarczyć. 

## Nginx

Instalujemy Nginx ze standardowymi modułami: 
    
    
    sudo apt-get install nginx

Zwykle pracuję z pseudodomenami _.dev_ (kuba.dev, mojprojekt.dev itd). Wszystkie obsługiwane są przez jedną konfigurację _(/etc/nginx/sites-available/dev_): 
    
    
    server {
        listen 80 default;
        server_name *.dev;
    
        root /var/www/$host/web;
    
        access_log /var/log/nginx/$host-access.log;
        error_log  /var/log/nginx/dev-error.log error;
    
        index index.php index.html index.htm;
    
        try_files $uri $uri/ @rewrite;
    
        location @rewrite {
            rewrite ^/(.*)$ /index.php/$1;
        }   
    
        location ~ \.php {
            # try_files $uri =404;
    
            fastcgi_index index.php;
            fastcgi_pass 127.0.0.1:9000;
    
            include fastcgi_params;
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_param PATH_INFO $fastcgi_path_info;
            fastcgi_param PATH_TRANSLATED $document_root$fastcgi_path_info;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        }
    
        location ~ /\.ht {
            deny all;
        }
    }

Musimy ją uaktywnić: 
    
    
    sudo ln -s /etc/nginx/sites-available/dev /etc/nginx/sites-enabled/dev

**Uwaga**: Szczegóły dotyczące poszczególnych opcji i dyrektyw Nginx opisałem w artykule "[Konfiguracja Nginx dla projektów Symfony](/konfiguracja-nginx-dla-projektow-symfony)" (konfiguracja jest dość uniwersalna). 

## Konfiguracja systemu

Dodajemy siebie do grupy _www-data_ i logujemy ponownie: 
    
    
    sudo usermod -a -G www-data kuba
    sudo su kuba

Robimy to, aby później nie nadużywać _sudo_ za każdym razem, gdy będziemy pracować nad jedną z naszych aplikacji. Wystarczy, że zadbamy, aby pliki należały do grupy _www-data_. Pozwalamy, aby wszyscy w grupie mogli tworzyć domeny: 
    
    
    sudo mkdir /var/www
    sudo chown -R www-data:www-data /var/www
    sudo chmod -R 775 /var/www

Definiujemy fikcyjne domeny _*.dev_ w _/etc/hosts_ (dużo wygodniej jest użyć dnsmasq, ale na początek plik hosts załatwi sprawę): 
    
    
    127.0.1.1 loki info.dev kuba.dev mojprojekt.dev

## Testy

Tworzymy stronę testową: 
    
    
    mkdir /var/www/info.dev/web -p
    echo "<?php echo phpinfo(); ?>" > /var/www/info.dev/web/index.php
    chown -R :www-data /var/www/info.dev
    chmod -R 775 /var/www/info.dev

Uruchamiamy php-fpm i Nginx: 
    
    
    sudo service php5-fpm start
    sudo service nginx start

Gdy teraz odwiedzimy _http://info.dev_ w przeglądarce, powinniśmy zobaczyć informacje o naszej instalacji PHP. ![](/uploads/wp/2011/05/phpinfo-400x367.png)
