---
title: Konfiguracja Nginx dla projektów Symfony
link: http://www.zalas.pl/konfiguracja-nginx-dla-projektow-symfony
author: admin
description: 
post_id: 856
created: 2011/04/29 06:25:46
created_gmt: 2011/04/29 05:25:46
comment_status: open
post_name: konfiguracja-nginx-dla-projektow-symfony
status: publish
post_type: post
---

<!--Z okazji wydania wersji 1.0.0 odświeżyłem nieco swoją wiedzę o Nginx. Od czasu, kiedy po raz pierwszy go konfigurowałem, wzbogacił się o kilka nowych dyrektyw i zmiennych. Dzięki temu mogłem uprościć swoją konfigurację dla projektów Symfony (zarówno symfony 1.x jak i Symfony2).-->

# Konfiguracja Nginx dla projektów Symfony

![](/uploads/wp/2011/04/nginx-symfony.png)Z okazji wydania wersji 1.0.0 odświeżyłem nieco swoją wiedzę o Nginx. Od czasu, kiedy po raz pierwszy go konfigurowałem, wzbogacił się o kilka nowych dyrektyw i zmiennych. Dzięki temu mogłem uprościć swoją konfigurację dla projektów Symfony (zarówno symfony 1.x jak i Symfony2). **Uwaga:** Konfiguracje dostępne w Internecie podatne są na wykonanie pliku niePHPowego jako PHP. Więcej o problemie w "[Setting up PHP-FastCGI and nginx? Don’t trust the tutorials: check your configuration!](https://nealpoole.com/blog/2011/04/setting-up-php-fastcgi-and-nginx-dont-trust-the-tutorials-check-your-configuration/)". O samej instalacji Nginx w Ubuntu przeczytacie w "[Konfiguracji środowiska deweloperskiego PHP z Nginx w Ubuntu 11.04](/konfiguracja-srodowiska-deweloperskiego-php-z-nginx-w-ubuntu-1104)". 

## Konfiguracja

Według konwencji konfigurację każdego hosta dodajemy do osobnego pliku w katalogu _/etc/nginx/sites-available/_ i tworzymy do niej dowiązanie symboliczne w _/etc/nginx/sites-enabled/_. Poniższe reguły dla domen deweloperskich umieścimy w _/etc/nginx/sites-available/dev_ i utworzymy do nich link _/etc/nginx/sites-enabled/dev_. 
    
    
    server {
        listen 80 default;
        server_name *.dev;
    
        root /var/www/$host/current/web;
    
        access_log /var/log/nginx/$host-access.log;
        error_log  /var/log/nginx/dev-error.log error;
    
        index app.php index.html index.htm;
    
        try_files $uri $uri/ @rewrite;
    
        location @rewrite {
            rewrite ^/(.*)$ /app.php/$1;
        }   
    
        location ~ \.php {
            # try_files $uri =404;
    
            fastcgi_index app.php;
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

## Wyjaśnienie konfiguracji
    
    
        listen 80 default;

Nginx domyślnie nasłuchuje na porcie 80. W tym fragmencie istotny jest drugi parameter - "default". Dzięki niemu aktualnie tworzona konfiguracja wirtualnego hosta będzie domyślną. 
    
    
        server_name *.dev;

Konfigurujemy dynamiczny wirtualny host, który akceptuje każdą domenę _.dev_ (_kuba.dev_, _mojprojekt.dev_ itd). Alternatywnie możemy podać listę domen  (np _server_name zalas.pl_). W takim przypadku każdy host zdefiniujemy w osobnej sekcji _server {}_. 
    
    
        root /var/www/$host/current/web;

Wskazujemy katalog główny domeny. Zostanie ustalony dynamicznie na podstawie zmiennej _$host_ (dla domeny _kuba.dev_ będzie to _/var/www/kuba.dev/current/web_)_._
    
    
        access_log /var/log/nginx/$host-access.log;
        error_log  /var/log/nginx/dev-error.log error;

Definiujemy pliki logów. Każda domena otrzyma swój własny access log. Niestety nie możemy użyć zmiennej _$host_ przy logowaniu błędów. Stąd wszystkie będą logowane do jednego pliku. 
    
    
        index app.php index.html index.htm;

Ustalamy pliki indeksu. Jeśli żądanie dotyczyć będzie katalogu, to nginx spróbuje wywołać pliki tutaj wypisane. W Symfony2 domyślny kontroler to zwykle _app.php_, a w symfony 1.x _index.php_. 
    
    
        try_files $uri $uri/ @rewrite;

Jest to bardzo elegancki sposób na czytelne URLe. Pozwala uniknąć [niezalecanych ifów](http://wiki.nginx.org/IfIsEvil). Serwer sprawdzi najpierw, czy istnieje plik o danym URI, następnie  poszuka katalogu, a na końcu skieruje żądanie do tzw _named location_. 
    
    
        location @rewrite {
            rewrite ^/(.*)$ /app.php/$1;
        }

Trafimy tutaj tylko, jeśli URI nie jest fizycznym plikiem lub katalogiem (w przeciwnym razie zadziała pierwszy lub drugi parametr dyrektywy _try_files_). Żądanie zostanie skierowane do domyślnego kontrolera (_app.php_). 
    
    
        location ~ \.php {
            fastcgi_index app.php;
            fastcgi_pass 127.0.0.1:9000;
    
            include fastcgi_params;
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_param PATH_INFO $fastcgi_path_info;
            fastcgi_param PATH_TRANSLATED $document_root$fastcgi_path_info;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        }

Wszystkie żądania do PHP zostaną przekierowane do demona fastcgi (działającego lokalnie na porcie 9000). Oprócz dołączenia standardowych parametrów fastcgi z pliku fastcgi_params, zadbaliśmy o poprawną definicję PATH_INFO i SCRIPT_FILENAME. _fastcgi_split_path_info_ podpowiada jak oddzielić plik kontrolera od ścieżki. 
    
    
        location ~ /\.ht {
            deny all;
        }

Ignorujemy apache'owe pliki .htaccess, które dla nginx są tylko zwykłymi, tekstowymi plikami (nie chcemy żeby były dostępne przez przeglądarkę).

## Comments

**[Włodzimierz Gajda](#3084 "2012-02-13 21:18:07"):** Krótko i na temat. Wielkie dzięki :-)

