---
title: Automatyczne ładowanie klas w dowolnym projekcie PHP z komponentem ClassLoader Symfony2
slug: automatyczne-ladowanie-klas-w-dowolnym-projekcie-php-z-komponentem-classloader-symfony2
author: Jakub Zalas
description: 
post_id: 933
created: 2011/06/30 19:42:39
created_gmt: 2011/06/30 18:42:39
comment_status: open
post_name: automatyczne-ladowanie-klas-w-dowolnym-projekcie-php-z-komponentem-classloader-symfony2
status: publish
layout: post
tags:
- autoloader
- ClassLoader
- components
- php
- Symfony2
expired: true
comments: true
---

[ClassLoader](https://github.com/symfony/ClassLoader) to komponent [Symfony2](http://symfony.com), który odpowiada za automatyczne ładowanie klas zgodnie ze [standardem PSR-0](http://groups.google.com/group/php-standards/web/psr-0-final-proposal). Poza współpracą z kodem używającym przestrzeni nazw (ang. namespace), działa ze staromodnym już [standardem PEAR](http://pear.php.net/manual/en/standards.naming.php) (używanym też w Zendzie). Komponent sprawdza się równie dobrze poza Symfony. **Uwaga**: Kod tworzony w tym wpisie jest dostępny na githubie: <https://github.com/jakzal/SymfonyComponentsExamples>

## Instalacja

Komponent możemy zainstalować z pomocą [kanału PEAR Symfony](http://pear.symfony.com/) lub go po prostu pobrać z [github](https://github.com/symfony/ClassLoader)a. Na potrzeby tego wpisu sklonujemy źródła do katalogu _vendor/_ naszego projektu. **Uwaga**: Komponent ClassLoader używa przestrzeni nazw _Symfony\Component\ClassLoader_. Dlatego umieścimy go w podkatalogu _vendor/Symfony/Component/ClassLoader_ (patrz [standard PSR-0](http://groups.google.com/group/php-standards/web/psr-0-final-proposal)). 
    
    
    git clone https://github.com/symfony/ClassLoader.git vendor/Symfony/Component/ClassLoader

## Podstawowe użycie

Załóżmy, że mamy dwie biblioteki: Acme i Legacy_Acme. Pierwszą umieściliśmy w katalogu _src/Acme/Tools_. Jest w niej klasa _HelloWorld, która_ używa przestrzeni nazw _Acme\Tools _i znajduje się w pliku _src/Acme/Tools/HelloWorld.php_: 
    
    
    <?php
    // src/Acme/Tools/HelloWorld.php
    
    namespace Acme\Tools;
    
    class HelloWorld
    {
        public function __construct()
        {
            echo __METHOD__."\n";
        }
    }

Drugą bibliotekę umieściliśmy w katalogu _src/Legacy/Acme/Tools_. Używa konwencji PEAR, dlatego klasa _Legacy_Acme_Tools_HelloWorld_ została zdefiniowana w pliku _src/Legacy/Acme/Tools/HelloWorld.php_: 
    
    
    <?php
    // src/Legacy/Acme/Tools/HelloWorld.php
    
    class Legacy_Acme_Tools_HelloWorld
    {
        public function __construct()
        {
               echo __METHOD__."\n";
        }
    }

Rejestrujemy przestrzeń nazw _Acme_ oraz prefiks _Legacy__, aby nasze klasy były automatycznie ładowane: 
    
    
    <?php
    // classloader.php
    
    require_once __DIR__.'/vendor/Symfony/Component/ClassLoader/UniversalClassLoader.php';
    $loader = new Symfony\Component\ClassLoader\UniversalClassLoader();
    $loader->registerNamespaces(array('Acme' => __DIR__ . '/src'));
    $loader->registerPrefixes(array('Legacy_' => __DIR__ . '/src'));
    $loader->register();
    
    $helloWorld = new Acme\Tools\HelloWorld();
    $legacyHelloWorld = new Legacy_Acme_Tools_HelloWorld();

Oczywiście klasy zostaną załadowane tylko wtedy, kiedy będą potrzebne. Ręczne ładowanie _UniversalClassLoader.php_ powinno być jedynym wywołaniem _require_ w naszym kodzie. Resztę klas załaduje autoloader. **Uwaga**: Możemy zdefiniować ścieżki metodami _registerNamespaceFallbacks()_ i _registerPrefixFallbacks()_. ClassLoader użyje ich z przestrzeniami nazw lub prefiksami nie podanymi jawnie przez _registerNamespaces()_ lub _registerPrefixes()_. 

## Poprawiamy wydajność

W prawdziwych projektach ilość klas jest raczej duża. ClassLoader może mieć negatywny wpływ na wydajność, ponieważ przed załadowaniem klasy sprawdza, czy jej plik istnieje. Powinniśmy używać _ApcUniversalClassLoader_, aby unikać niepotrzebnych operacji na dysku (ścieżki trzymane są wtedy w pamięci): 
    
    
    <?php
    // classloadercached.php
    
    require_once __DIR__.'/vendor/Symfony/Component/ClassLoader/UniversalClassLoader.php';
    require_once __DIR__.'/vendor/Symfony/Component/ClassLoader/ApcUniversalClassLoader.php';
    
    $loader = new Symfony\Component\ClassLoader\ApcUniversalClassLoader('ClassLoader');
    $loader->registerNamespaces(array('Acme' => __DIR__ . '/src'));
    $loader->registerPrefixes(array('Legacy_' => __DIR__ . '/src'));
    $loader->register();
    
    $helloWorld = new Acme\Tools\HelloWorld();
    $legacyHelloWorld = new Legacy_Acme_Tools_HelloWorld();

**Uwaga**: Przykłady uruchamiane są w konsoli, więc nie zyskamy na wydajności używając APC. Możemy nawet stracić, bo cache inicjalizowany będzie przy każdym uruchomieniu. Jest to ograniczenie APC.
