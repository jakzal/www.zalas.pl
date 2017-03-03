---
title: Automatyczne ładowanie klas w dowolnym projekcie PHP z komponentem ClassLoader Symfony2
link: http://www.zalas.pl/automatyczne-ladowanie-klas-w-dowolnym-projekcie-php-z-komponentem-classloader-symfony2
author: admin
description: 
post_id: 933
created: 2011/06/30 19:42:39
created_gmt: 2011/06/30 18:42:39
comment_status: open
post_name: automatyczne-ladowanie-klas-w-dowolnym-projekcie-php-z-komponentem-classloader-symfony2
status: publish
post_type: post
---

<!--ClassLoader to komponent Symfony2, który odpowiada za automatyczne ładowanie klas zgodnie ze standardem PSR-0. Poza współpracą z kodem używającym przestrzeni nazw (ang. namespace), działa ze staromodnym już standardem PEAR (używanym też w Zendzie). Komponent sprawdza się równie dobrze poza Symfony.-->

# Automatyczne ładowanie klas w dowolnym projekcie PHP z komponentem ClassLoader Symfony2

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

## Comments

**[Dawid](#3046 "2011-06-30 13:13:37"):** No i gdzie teraz masz przycisk „Lubię to”, żebym mógł Cię łatwo wypromować za ciekawy wpis? ;)

**[Kuba](#3047 "2011-06-30 13:20:19"):** Heh... mam przycisk "tweet", nie nada się? :P

**[Dawid](#3048 "2011-06-30 13:28:13"):** Niestety, ale większość moich kontaktów na tweeterze to strony, których nie obserwuję na rssach :]

**[Kuba](#3049 "2011-06-30 13:45:55"):** W każdym razie jakoś nie wpadłem na dodanie like'a. Muszę to naprawić ;) Dzięki za komentarze!

**[Mat](#3060 "2011-07-30 03:25:18"):** Z ApcUniversalClassLoader u mnie działa wolniej niż bez :))Nie wiem, być może to wina windowsa albo ostatnich optymalizacji S2 przed finalnym releasem ;)Mógłbyś porównać wydajność obu rozwiązań?

**[Kuba](#3061 "2011-07-30 10:42:01"):** @Mat jak masz skonfigurowane PHP? Dane w APC żyją nie dłużej niż proces PHP. Jeśli proces umiera, to APC jest przy każdym żądaniu puste i cache musi się wygenerować. Nie wiem jak to się odbywa na windowsie. Jeśli nie masz odpowiednika fastcgi lub modułu apache, których procesy używane są do obsługi wielu żądań, to w tym może być problem. Na przykład w zwykłym CGI przy każdym żądaniu tworzony jest nowy proces PHP. Zysku z APC nie ma, bo jest inicjalizowane za każdym razem od nowa. Jeśli już musisz pracować na Windowsie, to polecam przenieść chociaż środowisko programistyczne na wirtualną maszynę z systemem Linuksowym (np na VirtualBoksie).

**[Kuba](#3062 "2011-07-30 10:44:48"):** @Mat napisałem Ci odpowiedź, po czym uświadomiłem sobie, że moje przykłady uruchamiane są w konsoli. W takim przypadku zysk z APC jest żaden, bo każde uruchomienie skryptu z konsoli to nowy proces. W skryptach konsolowych nie ma więc sensu używać ApcUniversalClassLoader. Może się wręcz okazać, że tak jak w Twoim przypadku stracimy na wydajności. Dzięki za zwrócenie uwagi!

**[Mat](#3063 "2011-08-07 00:44:19"):** Czesc, do developmentu na windowsie uzywam WAMP. Do stress testow - ab. Potestuje jeszcze to na produkcji.

