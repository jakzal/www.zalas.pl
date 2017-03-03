---
title: Wyszukiwanie plików i katalogów w PHP z komponentem Finder Symfony2
link: http://www.zalas.pl/wyszukiwanie-plikow-i-katalogow-w-php-z-komponentem-finder-symfony2
author: admin
description: 
post_id: 965
created: 2011/07/07 18:38:18
created_gmt: 2011/07/07 16:38:18
comment_status: open
post_name: wyszukiwanie-plikow-i-katalogow-w-php-z-komponentem-finder-symfony2
status: publish
post_type: post
---

<!--Komponent Finder sprawia, że wyszukiwanie plików i katalogów w PHP przestaje być męczące. Pozwala na filtrowanie po nazwie, wzorcu, rozmiarze, dacie modyfikacji i kilku innych kryteriach. W wyniku dostaniemy listę obiektów klasy SplFileInfo, która oferuje wygodny interfejs do pozyskiwania szczegółów na temat plików i katalogów.-->

# Wyszukiwanie plików i katalogów w PHP z komponentem Finder Symfony2

![Zdjęcie autorstwa Paul Watsona: http://flic.kr/p/9HpBfjt](/uploads/wp/2011/07/sieve-150x150.jpg)[Komponent Finder](https://github.com/symfony/Finder) sprawia, że wyszukiwanie plików i katalogów w PHP przestaje być męczące. Pozwala na filtrowanie po nazwie, wzorcu, rozmiarze, dacie modyfikacji i kilku innych kryteriach. W wyniku dostaniemy listę obiektów klasy [SplFileInfo](http://php.net/splfileinfo), która oferuje wygodny interfejs do pozyskiwania szczegółów na temat plików i katalogów. **Uwaga**: Kod tworzony w tym wpisie jest dostępny na githubie: <https://github.com/jakzal/SymfonyComponentsExamples>

## Instalacja

Komponent możemy zainstalować za pomocą [kanału PEAR Symfony2](http://pear.symfony.com/) lub go po prostu pobrać z [github](https://github.com/symfony/Finder)a. Na potrzeby tego wpisu sklonujemy źródła do katalogu _vendor/_ naszego projektu. 
    
    
    git clone https://github.com/symfony/Finder.git vendor/Symfony/Component/Finder

Użyjemy ClassLoader, innego komponentu Symfony2, do automatycznego ładowania klas. Więcej o tym komponencie we wpisie  "[Automatyczne ładowanie klas w dowolnym projekcie PHP z komponentem ClassLoader Symfony2](/automatyczne-ladowanie-klas-w-dowolnym-projekcie-php-z-komponentem-classloader-symfony2)". Poniższy kod wystarczy, aby wszystkie klasy z dowolnego komponentu Symfony2 były automatycznie ładowane (zakładając, że komponenty są umieszczane w katalogu _vendor/Symfony/Component_): 
    
    
    <?php
    // src/autoload.php
    require_once __DIR__.'/../vendor/Symfony/Component/ClassLoader/UniversalClassLoader.php';
    
    $loader = new Symfony\Component\ClassLoader\UniversalClassLoader();
    $loader->registerNamespaces(array(
        'Symfony' => __DIR__.'/../vendor',
        'PSS'     => __DIR__
    ));
    $loader->register();

## Przykłady

Główną klasą komponentu, z którą będziemy pracować, to _Finder._ Po utworzeniu obiektu metodą _create()_ użyjemy płynnego interfejsu (ang. [fluent interface](http://en.wikipedia.org/wiki/Fluent_interface)), aby zdefiniować kryteria. Metod filtrujących i sortujących najlepiej nauczymy się ze źródeł klasy [Finder](https://github.com/symfony/Finder/blob/master/Finder.php). **Przykład 1**: Poniższy skrypt wypisze komponenty Symfony zainstalowane w katalogu _vendor/Symfony/Component_: 
    
    
    <?php
    // finderdir.php
    require_once __DIR__.'/src/autoload.php';
    
    use Symfony\Component\Finder as Finder;
    
    $components = Finder\Finder::create()
        ->directories()
        ->depth(0)
        ->in('vendor/Symfony/Component');
    
    echo "Installed Symfony components:\n";
    foreach ($components as $dir) {
        printf("* %s \n", $dir->getFilename());
    }

**Przykład 2, bardziej wyrafinowany**: Poniższy skrypt wypisze pliki pasujące do wzorca _/^He.+Command.php$/_, mniejsze niż _4kb_ i zmodyfikowane _do wczoraj_. Wynik zostanie posortowany po _nazwie pliku_, a szukać będziemy w _aktualnym katalogu_: 
    
    
    <?php
    // finder.php
    require_once __DIR__.'/src/autoload.php';
    
    use Symfony\Component\Finder as Finder;
    
    $files = Finder\Finder::create()
        ->files()
        ->name('/^He.+Command.php$/')
        ->size('<4k')
        ->date('until yesterday')
        ->sortByName()
        ->in('.');
    
    echo "Command files starting with 'He' below 4k modified until yesterday:\n";
    foreach ($files as $file) {
        printf("* %s %s\n", $file->getFilename(), date('Y-m-d H:i', $file->getMTime()));
    }

Proste, nieprawdaż?

## Comments

**[dominik](#3050 "2011-07-08 00:57:41"):** Wygląda ślicznie, tylko martwi mnie skąd "until" dostało dodatkową literkę? Czy on to tak rozumie (!), czy to literówka?

**[Kuba](#3051 "2011-07-08 01:40:52"):** @dominik: literówka, poprawione, dzięki :)

**[dominik](#3054 "2011-07-11 01:12:49"):** Jeszcze zostało "echo" tego problemu kawałek dalej ;) A klasa wygląda rzeczywiście bardzo ładnie, jak tylko będzie trochę operacji dyskowych to się chętnie z nią bliżej poznam :)

**[Kuba](#3055 "2011-07-11 07:44:13"):** Jak dobrze, gdy jest ktoś, kto poprawi Twoje błędy ;)

