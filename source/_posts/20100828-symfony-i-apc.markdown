title: Symfony i APC
link: http://www.zalas.pl/symfony-i-apc
author: admin
description: 
post_id: 646
created: 2010/08/28 18:47:04
created_gmt: 2010/08/28 17:47:04
comment_status: open
post_name: symfony-i-apc
status: publish
post_type: post

<!--Do niedawna byłem wyłącznie użytkownikiem XCache (jeśli chodzi o akceleratory PHP). Ostatnio potrzebowałem użyć APC w aplikacji symfony. Poszło mi całkiem gładko jako, że framework bardzo ładnie integruje się z najpopularniejszymi rozwiązaniami tego typu.-->

# Symfony i APC

Do niedawna byłem wyłącznie użytkownikiem [XCache](http://xcache.lighttpd.net/) (jeśli chodzi o akceleratory PHP). Ostatnio potrzebowałem użyć [APC](http://php.net/apc) w aplikacji symfony. Poszło mi całkiem gładko jako, że framework bardzo ładnie integruje się z najpopularniejszymi rozwiązaniami tego typu.****

## Akceleratory PHP w symfony

Symfony daje możliwość zmiany strategii cache'owania dla widoku, i18n i routingu. Dodatkowo Doctrine umie cache'ować skompilowane zapytania DQL oraz ich wyniki. Strategie cache'owania w symfony implementuje się dziedzicząc po klasie _sfCache_. Obsługa **APC** zaimplementowana jest w _sfAPCCache_. Każdy z popularnych akceleratorów ma swoją klasę: **XCache** (_sfXCacheCache_), **EAccelerator** (_sfEacceleratorCache_), **memcache** (_sfMemcacheCache_) i **SQLite** (_sfSQLiteCache_). Poniższy opis można zastosować do dowolnego z wyżej wymienionych rozwiązań. Wystarczy tylko zmienić nazwę klasy. 

## APC w symfony

Cache'owanie w plikach jest domyślną strategią cache'owania w symfony (_sfFileCache_). Możemy to zmienić dla routingu, widoku i tłumaczeń w pliku fabryk (na przykład _apps/frontend/config/factories.yml_ lub _config/factories.yml_): 
    
    
    all:
      routing:
        class: sfPatternRouting
        param:
          generate_shortest_url:            true
          extra_parameters_as_query_string: true
          cache:
            class: sfAPCCache
            param:
              automatic_cleaning_factor: 0
              lifetime:                  31556926
    
      view_cache:
        class: sfAPCCache
    
      i18n:
        param:
          cache:
            class: sfAPCCache
            param:
              automatic_cleaning_factor: 0
              lifetime:                  31556926

Od tej pory cache routingu, widoku i tłumaczeń trzymany będzie w pamięci. Dzięki temu z każdym żądaniem strony symfony wykona o wiele mniej operacji na dysku (które z natury są wolne). 

## Cache DQL i wyników zapytań w Doctrine

Włączenie cache'owania zapytań DQL jest dość bezpiecznym ruchem. Pod warunkiem, że nie tworzymy ich poprzez sklejanie tekstu, a używamy prepared statements! Jest tak dlatego, że z parametrów przekazanych do zapytania generowany jest unikalny identyfikator, który następnie jest używany przy wyciąganiu zapytania z cache'u. W symfony Doctrine konfigurujemy w metodzie _configureDoctrine()_ klasy konfiguracji projektu (_config/ProjectConfiguration.class.php_). W celu włączenia cache'owania skompilowanych zapytań DQL ustawiamy atrybut _ATTR_QUERY_CACHE_ na odpowiednią wartość: 
    
    
    /**
     * @param Doctrine_Manager $manager
     * @return null
     */
    public function configureDoctrine(Doctrine_Manager $manager)
    {
      $manager->setAttribute(Doctrine_Core::ATTR_QUERY_CACHE, new Doctrine_Cache_Apc());
    }

Cache'owanie wyników zapytań jest nieco trudniejsze. Samo włączenie mechanizmu jest równie proste:: 
    
    
    $manager->setAttribute(Doctrine_Core::ATTR_RESULT_CACHE, new Doctrine_Cache_Apc());

Jednak cache'owanie wszystkich wyników zapytań nie jest dobrym pomysłem w większości projektów. Czas życia każdego z wyników może różnić się znacząco. Jedne dane nie zmieniają się tygodniami, a inne są tak dynamiczne, że wcale nie warto ich cache'ować (są nieaktualne w momencie pobrania). Możemy też włączyć cache tylko dla wybranego połączenia: 
    
    
    $connection->setAttribute(Doctrine_Core::ATTR_RESULT_CACHE, new Doctrine_Cache_Apc());

Jednak najprzydatniejsze wydaje się być cache'owanie wybranych zapytań: 
    
    
    $query = Doctrine_Query::create()
      ->useResultCache(new Doctrine_Cache_Apc());

Dokumentacja Doctrine szerzej opisuje tematykę cache'owania zapytań i wyników w sekcji [Query Cache & Result Cache](http://www.doctrine-project.org/documentation/manual/1_2/en/caching:query-cache-&-result-cache). 

## Przyszłość APC

Dawno temu wybrałem XCache ponieważ w tamtym okresie miał lepsze wsparcie, a różnic w wydajności nie było. Dzisiaj, kiedy APC jest aktywnie rozwijane i są plany jego włączenia do jądra PHP, muszę przemyśleć temat ponownie. A Wy? Czego używacie? Dlaczego? Robiliście testy?