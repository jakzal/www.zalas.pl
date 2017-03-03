---
title: Automatyczne publikowanie aplikacji Symfony na wiele serwerów z Capifony
slug: automatyczne-publikowanie-aplikacji-symfony-na-wiele-serwerow-z-capifony
author: Jakub Zalas
description: 
post_id: 837
created: 2011/04/23 10:53:29
created_gmt: 2011/04/23 09:53:29
comment_status: open
post_name: automatyczne-publikowanie-aplikacji-symfony-na-wiele-serwerow-z-capifony
status: publish
post_type: post
---

<!--Capifony to zestaw recept Capistrano do publikowania aplikacji napisanych w symfony lub Symfony2. Multistage jest rozszerzeniem Capistrano. Ułatwia publikację kodu na kilka serwerów, które różnią się nieco konfiguracją lub procesem publikacji.-->

# Automatyczne publikowanie aplikacji Symfony na wiele serwerów z Capifony

**![](/uploads/wp/2011/04/Symfony2-capistrano-multistage-files-227x400.png)Capifony** to zestaw recept **Capistrano** do publikowania aplikacji napisanych w **symfony** lub **Symfony2**. **Multistage** jest rozszerzeniem Capistrano. Ułatwia publikację kodu na wiele serwerów, które różnią się nieco konfiguracją lub procesem publikacji. **Uwaga**: Jeśli nie znasz [capistrano](https://github.com/capistrano/capistrano/wiki) lub [capifony](http://capifony.org/) to jest właściwy moment, aby odwiedzić ich strony i poczytać o automatycznym publikowaniu kodu. O zaletach tego typu rozwiązań pisałem już w artykule[ "Automatyczne publikowanie aplikacji PHP](/automatyczne-publikowanie-aplikacji-php)". 

## Dlaczego multistage?

[Staging](http://en.wikipedia.org/wiki/Staging_%28websites%29) to popularna technika testowania aplikacji zanim dotrze na produkcję. Polega na publikowaniu aplikacji na serwery akceptacyjne (testowe), przed docelową publikacją dostępną dla użytkownika końcowego. W ten sposób weryfikujemy działanie aplikacji w warunkach podobnych do produkcyjnych, ale bez narażania się na klęskę przed całym światem. Chociaż wszystkie środowiska, na które publikujemy kod powinny być takie same, często chcemy aby w jakiś sposób się różniły. Najczęściej chodzi o drobne zmiany w procesie "budowania" kodu lub konfiguracji. Przykładowo nie chcemy używać kontrolerów deweloperskich na produkcji, ale na teście mogą być przydatne do diagnozy błędów. Jest to różnica w procesie. Na produkcji uruchamiamy dodatkowy task, który usuwa kontrolery. Z drugiej strony na serwerze testowym nie chcemy zwykle używać Google Analytics, ale produkcyjny powinien je mieć włączone. To jest różnica w konfiguracji. [Rozszerzenie multistage](https://github.com/capistrano/capistrano/wiki/2.x-Multistage-Extension) pomoże nam z tego typu rożnicami. 

## Instalacja
    
    
    gem install capifony capistrano-ext

## Kapifonikacja projektu ;)
    
    
    cd /path/to/myproject
    capifony .

## Przykład multistage

Podstawowe rzeczy jakie musimy zrobić to załączenie rozszerzenia i zdefiniowanie etapów (stages). W tym celu zastąpimy zawartość _app/config/deploy.rb_ następującą treścią: 
    
    
    set :stage_dir, 'app/config/deploy' # potrzebne tylko w Symfony2
    require 'capistrano/ext/multistage'
    set :stages, %w(production testing development)
    
    set :application, "MyApp"
    
    set :repository,  "mycompany.com:/var/repos/#{application}.git"
    set :scm,         :git
    
    set  :keep_releases,  3

**Uwaga**: W przypadku aplikacji napisanej w symfony 1.x musimy usunąć  '_app/_' ze wszystkich ścieżek do plików konfiguracyjny opisywanych w tym artykule Production, testing i development to nasze etapy (stages). Dla każdego etapu musimy stworzyć osobny plik konfiguracyjny w katalogu _app/config/deploy_. Oto przykład dla etapu production (_app/config/deploy/production.rb_): 
    
    
    server 'myapp.com', :app, :web, :primary => true
    set :deploy_to, "/var/www/myapp.com/"
    
    after 'deploy:finalize_update', 'symfony:project:clear_controllers'

Publikacja na serwer testowy potencjalnie będzie wyglądać nieco inaczej (_app/config/deploy/testing.rb_): 
    
    
    server 'test.myapp.mycompany.com', :app, :web, :primary => true
    set :deploy_to, "/var/www/test/myapp.mycompany.com/"
    set :symfony_env_prod, "test"

Podczas publikacji musimy teraz podać cel (etap): 
    
    
    cap production deploy

W plikach etapów możemy zrobić wszystko co jest możliwe w Capistrano: 

  * podpiąc wywołania dodatkowych tasków i zmienić proces publikacji dla danego etapu
  * zmienić zachowanie istniejących tasków
  * rozszerzyć istniejące namespace'y o nowe taski
  * utworzyć nowy namespace z własnymi taskami
W praktyce taski i namespace'y rzadko różnią się pomiędzy etapami. Najczęściej będziemy potrzebować zmienionej konfiguracji lub procesu. 
    
    
    set :symfony_env_prod, "new_prod_env"

## Comments

**[dominik](#3041 "2011-04-27 03:59:39"):** Ja wciąż utknąłem przy phingu i jego operacjach, ale mam stosunkowo łatwo wydawalne projekty, więc nie ma co się rozwodzić nad tym, dodatkowe plusy to to że można dodać nie tylko wydawanie, ale i inne dodatki. Przy produkcji natomiast ciągle trzeba uważać, coby nie rozwalić realnych danych. Jak będzie sposobność to z pewnością sprawdzę capifony, brzmi ciekawie :)jedna uwaga techniczna - w pl. nie używamy apostrofów, ale piszemy normalnie, nawet zamieniając iks (chociaż od tego jest drobna dwuznaczność) :) np w linkuksie, a nie w linux'sie itd. :)

