title: Symphony CMS na nginx
link: http://www.zalas.pl/symphony-cms-na-nginx
author: admin
description: 
post_id: 284
created: 2009/07/09 15:56:40
created_gmt: 2009/07/09 14:56:40
comment_status: open
post_name: symphony-cms-na-nginx
status: publish
post_type: post

<!--Zdecydowałem się przetetsować CMS o nazwie Symphony z dwóch powodów. Pierwszym były dokładnie określone fazy tworzenia stron internetowych, które wymusza sam CMS. Drugim powodem był oparty o XSLT system szablonów. Jak większość aplikacji PHP, Symphony zostało stworzone głównie z myślą o serwerze apache. Ponieważ od pewnego czasu preferuję używać nginx-a, napotkałem na małe problemy konfiguracyjne.-->

# Symphony CMS na nginx

Zdecydowałem się przetetsować CMS o nazwie [Symphony](http://symphony-cms.com/) z dwóch powodów. Pierwszym były dokładnie określone fazy tworzenia stron internetowych, które wymusza sam CMS. Drugim powodem był oparty o XSLT system szablonów. Jak większość aplikacji PHP, Symphony zostało stworzone głównie z myślą o serwerze apache. Ponieważ od pewnego czasu preferuję używać [nginx](http://nginx.net/)-a, napotkałem na małe problemy konfiguracyjne. Podczas instalacji Symphony tworzy plik .htaccess z regułkami dla czystych URLi. Oczywiste jest, że działa to tylko w apache'u. Regułki musiały zostać przetłumaczone na format akceptowany przez nginx i dodane do definicji wirtualnego hosta. Oto moja w pełni działająca konfiguracja dla domen obsługujących Symphony (powinna zostać umieszczona w sekcji http): 
    
    
    server {
      listen 80;
      server_name *.symphony.dev;
      root /var/www/$host/web;
      index index.php;
    
      access_log /var/log/nginx/symphony.dev-access.log;
      error_log /var/log/nginx/symphony.dev-error.log error;
    
      location / {
        # serve static files directly
        if (-f $request_filename) {
          access_log        off;
          expires           30d;
          break;
        }
    
        ### BACKEND
        if ($request_filename ~ /symphony/) {
          rewrite ^/symphony/(.*)$ /symphony/index.php?page=$1 last;
        }
    
        ### IMAGE RULES
        rewrite ^/image/(.+\.(jpg|gif|jpeg|png|bmp|JPG|GIF|JPEG|PNG|BMP))$ /extensions/jit_image_manipulation/lib/image.php?param=$1 last;
    
        ### CHECK FOR TRAILING SLASH - Will ignore files
        if (!-f $request_filename) {
            rewrite ^/(.*[^/]+)$ /$1/ permanent;
        }
    
        ### MAIN REWRITE - This will ignore directories
        if (!-d $request_filename) {
            rewrite ^/(.*)$ /index.php?page=$1 last;
        }
      }
    
      location ~ \.php($|/) {
        fastcgi_index index.php;
    
        set  $script     $uri;
        set  $path_info  "";
        if ($uri ~ "^(.+\.php)(/.*)") {
          set  $script     $1;
          set  $path_info  $2;
        }
        fastcgi_pass   127.0.0.1:9000;
        include /etc/nginx/fastcgi_params;
        fastcgi_param  SCRIPT_FILENAME  /var/www/$host/web/$script;
        fastcgi_param  PATH_INFO        $path_info;
        fastcgi_param  SCRIPT_NAME $script;
        fastcgi_param  SERVER_NAME $host;
      }
    
      location ~ /\.ht {
        deny  all;
      }
    }

Potrzebny jest również plik z parametrami dla fastcgi (plik _fastcgi_params)_: 
    
    
    fastcgi_param  QUERY_STRING       $query_string;
    fastcgi_param  REQUEST_METHOD     $request_method;
    fastcgi_param  CONTENT_TYPE       $content_type;
    fastcgi_param  CONTENT_LENGTH     $content_length;
    
    fastcgi_param  SCRIPT_NAME        $fastcgi_script_name;
    fastcgi_param  REQUEST_URI        $request_uri;
    fastcgi_param  DOCUMENT_URI       $document_uri;
    fastcgi_param  DOCUMENT_ROOT      $document_root;
    fastcgi_param  SERVER_PROTOCOL    $server_protocol;
    
    fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
    fastcgi_param  SERVER_SOFTWARE    nginx/$nginx_version;
    
    fastcgi_param  REMOTE_ADDR        $remote_addr;
    fastcgi_param  REMOTE_PORT        $remote_port;
    fastcgi_param  SERVER_ADDR        $server_addr;
    fastcgi_param  SERVER_PORT        $server_port;
    fastcgi_param  SERVER_NAME        $host;
    
    # PHP only, required if PHP was built with --enable-force-cgi-redirect
    fastcgi_param  REDIRECT_STATUS    200;