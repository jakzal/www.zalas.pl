---
title: PHP 5.3 zostało wydane
slug: php-53-zostalo-wydane
author: Jakub Zalas
description: 
post_id: 269
created: 2009/06/30 23:33:40
created_gmt: 2009/06/30 22:33:40
comment_status: open
post_name: php-53-zostalo-wydane
status: publish
layout: post
expired: true
comments: true
tags: [php]
---

[PHP 5.3 zostało wydane](http://php.net/releases/5_3_0.php). Wersja była długo oczekiwana z uwagi na wiele usprawnień, nowych funkcjonalności i poprawionych błędów. PHP 5.3 to prawie 6, tylko bez wsparcia dla Unicode. Oto lista rzeczy, na które szczególnie czekałem lub wydały mi się interesujące.

## Opcjonalny odśmiecacz pamięci

Do tej pory PHP cierpiało na wycieki pamięci przy okazji występowania cyklicznych referencji. Problem został bardzo dobrze opisany w artykule Dericka Rethansa w _Collecting Garbage: PHP's Take on Variables _(opublikowanym w [kwietniowym numerze php|architect](http://phparch.com/magazine/index/95)). W PHP 5.3 dostępna jest rodzina funkcji [odśmiecacza pamięci](http://php.net/gc_enable) (gc_*), które pozwalają nam lepiej ją kontrolować. 

## Lepsza wydajność

Informacja o nowym wydaniu wspomina o  "ukrytej, polepszonej wydajności". Nie ujawniono więcej szczegółów, jednak o tych sprawach zawsze jest dobrze usłyszeć ;) 

## Przestrzenie nazw

[Przestrzenie nazw](http://php.net/namespaces) w PHP zostały zaprojektowane do rozwiązania dwóch problemów: unikania konfliktów nazw i polepszenia czytelności. Konflikty występują głównie tam gdzie nasz kod spotyka się z zewnętrznymi bibliotekami. Czasem zdaża się, że nazwy klas czy funkcji powtarzają się. Przestrzenie nazw pomagają unikać takich przypadków i dodatkowo, pośrednio poprawiają czytelność kodu. Umieszczając definicje klas w różnych przestrzeniach, nie musimy już nadawać im długich, unikalnych nazw. 

## Potrójny operator

Od teraz możliwe jest pominięcie środkowej części operatora potrójnego, stanowiącego skrót dla warunku if. Zamiast pisać: 
    
    
    echo $test ? $test : 'brak';

możemy użyć skrótu: 
    
    
    echo $test ?: 'brak';

Operator szczególnie przyda się w plikach widoku, gdzie uczyni instrukcje krótszymi i bardziej czytelnymi. 

## Funkcje Lambda i domknięcia

[Domknięcia](http://php.net/closures), znane także jako funkcje anonimowe, pozwalają na deklarowanie funkcji bez określonej nazwy. Ich głównym przeznaczeniem jest "użyj i zapomnij", dlatego szczególnie sprawdzają się jako parametry typu callback. 
    
    
    $values = array_map(
      function ($value) { 
        return strtoupper($value) 
      }, 
      array('a', 'b', 'c')
    );

Wymyślono już [wiele przykładów zastosowania](http://www.google.com/search?&q=lambda+functions+and+closures+in+php) tych funkcji i niektóre wyglądają naprawdę zniechęcająco. Oddane w niepowołane ręce mogą uczynić wiele szkód. Jak każde potężne narzędzie, powinno być używane z rozwagą. 

## goto

[Goto](http://pl2.php.net/goto) wywołało kontrowersyjne dyskusje jeszcze przed wydaniem PHP 5.3. W jakim celu dodano do języka instrukcję znienawidzoną w niemal całym programistycznym świecie? 

![goto według xkcd](/uploads/wp//2009/07/goto.png)

## Rozszeżenie phar

Rozszeżenie phar udostępnia ciekawą funkcjonalność, zbliżoną do znanych z javy plików JAR. Pozwala na spakowanie całej aplikacji do jednego pliku [phar](http://php.net/phar) (PHP Archive - Archiwum PHP). Z założenia ma ułatwić proces dystrybucji pakietów. 

## Co dalej?

Migracja! Jest już dostępny [przewodnik do migracji](http://php.net/migration53). Najwyższy czas go przeczytać i poznać zmiany w stosunku do wersji 5.2. Występują pewne [niekompatybilności](http://php.net/manual/en/migration53.incompatible.php), ale koniec końców nie jest to główne wydanie i migracja powinna pójść dość gładko. Jeśli używacie gotowych bibliotek czy frameworków, najlepiej poczekać na wydania kompatybilne z PHP 5.3.
