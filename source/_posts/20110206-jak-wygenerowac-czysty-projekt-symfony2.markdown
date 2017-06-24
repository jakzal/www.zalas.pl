---
title: Jak wygenerować czysty projekt Symfony2?
slug: jak-wygenerowac-czysty-projekt-symfony2
author: Jakub Zalas
description: 
post_id: 715
created: 2011/02/06 23:14:56
created_gmt: 2011/02/06 22:14:56
comment_status: open
post_name: jak-wygenerowac-czysty-projekt-symfony2
status: publish
layout: post
tags:
- git
- onTheEdge
- php
- Symfony2
expired: true
comments: true
---

<!--Symfony2 nie jest jeszcze skończone, a jego wydanie planowane jest na marzec tego roku. Nie mogąc już dłużej czekać, zacząłem bawić się tym frameworkiem nieco poważniej. 

Ponieważ lubię wiedzieć co się dzieje, po kilku testach z gotowym szkieletem projektu (tzw sandbox) zapragnąłem wygenerować czysty. -->

# Jak wygenerować czysty projekt Symfony2?

[Symfony2](http://symfony-reloaded.org/) nie jest jeszcze skończone, a jego wydanie planowane jest na marzec tego roku. Nie mogąc już dłużej czekać, zacząłem bawić się tym frameworkiem nieco poważniej. Ponieważ lubię wiedzieć co się dzieje, po kilku testach z gotowym szkieletem projektu (tzw sandbox) zapragnąłem wygenerować czysty. **Uwaga:** opisywany tutaj symfony-bootstrapper został zarzucony i jest już nie utrzymywany. Jest już kilka artykułów na ten temat. Wszystkie opisują [symfony-bootstrapper](https://github.com/symfony/symfony-bootstrapper): 

  * [Make your own Symfony2 sandbox (the easy way)](http://www.webpragmatist.com/2010/11/make-your-own-symfony2-sandbox.html) (by [@webPragmatist](http://twitter.com/webPragmatist))
  * [Symfony2 project initialization](http://blog.bearwoods.dk/symfony2-project-initilization) (by [@henrikbjorn](http://twitter.com/henrikbjorn))
  * [Symfony2 project from scratch](http://www.fizyk.net.pl/blog/symony2-project-from-scratch)
Symfony2 cały czas ewoluuje. Myślę, że dla kogoś kto chce być na bieżąco najlepiej jest podłączyć zależności jako submoduły w gicie. Zaczynamy od pobrania bootstrappera Symfony2: 
    
    
    git clone git://github.com/symfony/symfony-bootstrapper.git ~/workspace/lib/Symfony2-bootstrapper

Tworzymy katalog na projekt i inicjalizujemy repozytorium git: 
    
    
    mkdir ~/workspace/projects/FooBar
    cd ~/workspace/projects/FooBar
    git init .

Teraz możemy wygenerować podstawową strukturę projektu za pomocą bootstrappera: 
    
    
    cd ~/workspace/projects/FooBar
    php ~/workspace/lib/Symfony2-bootstrapper/symfony.phar init --name 'FooBar' --format="yml"
    git add app/ src/ web/
    git commit -m 'Wygenerowałem aplikację Symfony2.'

Na koniec podłączamy Symfony2 i inne zależności jako submoduły gita: 
    
    
    cd ~/workspace/projects/FooBar
    git submodule add git://github.com/symfony/symfony.git src/vendor/symfony
    cat src/vendor/symfony/install_vendors.sh | grep "git clone" | awk '{print "git submodule add "$3" src/vendor/"$4}' | while read line; do $line; done
    git commit -m 'Dodałem submoduły z zależnościami.'

**Uwaga**: W momencie pisania tego artykułu istniał [mały defekt w bootstrapperze](https://github.com/symfony/symfony-bootstrapper/issues#issue/10).  Niedawno klasa [UniversalClassLoader została przeniesiona do osobnego komponentu](https://github.com/symfony/symfony/commit/42f9c556a35af616d3239df64f42c15b98602472). Jednak bootstrapper szuka jej w poprzednim miejscu. Wysłałem [poprawkę](https://github.com/jakzal/symfony-bootstrapper/commit/61abd3eb571b238783218b6f675f4baf59cbcf66), ale jeszcze [nie została włączona](https://github.com/symfony/symfony-bootstrapper/pull/10). Tymczasowo wystarczy zmodyfikować ścieżkę w the _src/autoload.php_ wygenerowanego projektu (trzeba zamienić _HttpFoundation _na _ClassLoader_ w ścieżce do pliku _UniversalClassLoader.php_).
