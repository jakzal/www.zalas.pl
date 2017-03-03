---
title: Kompilacja Doctrine w symfony 1.4
slug: kompilacja-doctrine-w-symfony
author: Jakub Zalas
description: 
post_id: 871
created: 2011/04/27 21:05:10
created_gmt: 2011/04/27 20:05:10
comment_status: open
post_name: kompilacja-doctrine-w-symfony
status: publish
post_type: post
---

<!--Z reguły przy profilowaniu aplikacji symfony 1.x wychodzi, że budowanie obiektów przez Doctrine jest jedną z bardziej pracochłonnych operacji. Ostatnio miałem ciekawszy przypadek. Znaczącą część czasu wykonania skryptu zajmowało ładowanie klas ORMa (require_once!). W normalnych warunkach tego typu operacje są prawie niewidoczne.-->

# Kompilacja Doctrine w symfony 1.4

![](/uploads/wp/2011/04/doctrine.png) Z reguły przy profilowaniu aplikacji symfony 1.x wychodzi, że budowanie obiektów przez Doctrine jest jedną z bardziej pracochłonnych operacji. Ostatnio miałem ciekawszy przypadek. Znaczącą część czasu wykonania skryptu zajmowało ładowanie klas ORMa (_require_once_!). W normalnych warunkach tego typu operacje są prawie niewidoczne. Z pomocą przyszedł mechanizm kompilacji, który łączy pliki z głównymi klasami Doctrine w jeden. Dzięki temu większość klas potrzebnych Doctrine podczas żądania załączanych jest tylko raz. W pluginie [sfTaskExtraPlugin](http://www.symfony-project.org/plugins/sfTaskExtraPlugin) znajdziemy task _doctrine:compile_, który realizuje to zadanie. **Notatka**:  serwer, na którym zainstalowano wspomnianą aplikację miał więcej problemów (np źle skonfigurowane APC). Uwydatniły one problem wolnego ładowania klas. Nie mniej jednak kompilacja miała swój wkład w poprawę wydajności. 

## Instalacja sfTaskExtraPlugin
    
    
    ./symfony plugin:install sfTaskExtraPlugin

## Kompilacja Doctrine

Doctrine skompilujemy tylko ze wsparciem dla mysql, a wynik zapiszemy do pliku _lib/doctrine.compiled.php_: 
    
    
    ./symfony doctrine:compile --driver=mysql lib/doctrine.compiled.php

Tak jak zasugeruje nam komunikat po kompilacji, załączamy skompilowany plik w _ProjectConfiguration_: 
    
    
    public function setup()
    {
      // ...
    
      if ($this instanceof sfApplicationConfiguration && !$this->isDebug())
      {
        require_once sfConfig::get('sf_lib_dir') . '/doctrine.compiled.php';
      }
    }

Warunkiem poprawnego działania aplikacji po kompilacji jest używanie klasy _Doctrine_Core_, a nie _Doctrine_. Task działa z najnowszymi wersjami symfony 1.3 i 1.4.
