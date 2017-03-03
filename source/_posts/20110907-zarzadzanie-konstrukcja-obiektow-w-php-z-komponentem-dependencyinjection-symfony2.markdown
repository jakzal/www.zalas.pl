---
title: Zarządzanie konstrukcją obiektów w PHP z komponentem DependencyInjection Symfony2
slug: zarzadzanie-konstrukcja-obiektow-w-php-z-komponentem-dependencyinjection-symfony2
author: Jakub Zalas
description: 
post_id: 993
created: 2011/09/07 08:00:01
created_gmt: 2011/09/07 06:00:01
comment_status: open
post_name: zarzadzanie-konstrukcja-obiektow-w-php-z-komponentem-dependencyinjection-symfony2
status: publish
post_type: post
---

<!--Komponent DependencyInjection Symfony2 to PHPowa implementacja kontenera usług (z ang. Dependency Injection Container). Dodatkowo, komponent zawiera kilka przydatnych narzędzi, pozwalających na import i eksport definicji w różnych formatach (np XML).-->

# Zarządzanie konstrukcją obiektów w PHP z komponentem DependencyInjection Symfony2

Komponent [DependencyInjection](https://github.com/symfony/DependencyInjection) Symfony2 to PHPowa implementacja **kontenera usług** (z ang. **Dependency Injection Container**). Dodatkowo, komponent zawiera kilka przydatnych narzędzi, pozwalających na import i eksport definicji w różnych formatach (np _XML_). 

![](/uploads/wp/2011/08/injection1.png)źródło zdjęcia: <http://www.flickr.com/photos/alexnormand/3132689510/>

Jeśli chcecie dowiedzieć się więcej o kontenerze usług lub wstrzykiwaniu zależności, polecam świetną serię artykułów autorstwa Fabiena Potencier: [What is Dependency Injection?](http://fabien.potencier.org/article/11/what-is-dependency-injection) **Uwaga**: Kod z tego artykułu dostępny jest na githubie: <https://github.com/jakzal/SymfonyComponentsExamples>

## Instalacja

Komponent możemy zainstalować za pomocą [kanału PEAR Symfony2](http://pear.symfony.com/) lub go po prostu pobrać z [github](https://github.com/symfony/Finder)a. Na potrzeby tego wpisu sklonujemy źródła do katalogu _vendor/_ naszego projektu. Będziemy też potrzebować Buzz, lekkiego klienta HTTP, który posłuży nam za przykład usługi. W jednym z fragmentów kodu pojawi się komponent [Config](https://github.com/symfony/Config/). 
    
    
    git clone https://github.com/symfony/DependencyInjection.git vendor/Symfony/Component/DependencyInjection
    git clone https://github.com/symfony/Config.git vendor/Symfony/Component/Config
    git clone https://github.com/symfony/ClassLoader.git vendor/Symfony/Component/ClassLoader
    git clone https://github.com/kriswallsmith/Buzz.git vendor/Buzz

Użyjemy komponentu ClassLoader do automatycznego ładowania klas. Więcej o nim przeczytacie we wpisie  "[Automatyczne ładowanie klas w dowolnym projekcie PHP z komponentem ClassLoader Symfony2](/automatyczne-ladowanie-klas-w-dowolnym-projekcie-php-z-komponentem-classloader-symfony2)". Poniższy kod wystarczy, aby wszystkie klasy z dowolnego komponentu Symfony2 były automatycznie ładowane (zakładając, że komponenty są umieszczane w katalogu _vendor/Symfony/Component_): 
    
    
    <?php
    // src/autoload.php
    require_once __DIR__.'/../vendor/Symfony/Component/ClassLoader/UniversalClassLoader.php';
    
    $loader = new Symfony\Component\ClassLoader\UniversalClassLoader();
    $loader->registerNamespaces(array(
        'Symfony' => __DIR__.'/../vendor',
        'Buzz'    => __DIR__.'/../vendor/Buzz/lib',
        'PSS'     => __DIR__
    ));
    $loader->register();

## Tworzenie obiektów (metoda klasyczna)

Buzz jest klientem HTTP. Z jego pomocą możemy wysyłać żądanie do strony www i odebrać odpowiedź: 
    
    
    $browser = new \Buzz\Browser();
    $response = $browser->get('http://www.google.com');

Domyślnie Buzz używa do połączeń strategii _FileGetContents_, która opakowuje funkcję _file_get_contents()_. Wyobraźmy sobie, że nowe wymagania wymusiły na nas użycie curla. Nic prostszego. Wystarczy, że przekażemy odpowiedniego klienta do obiektu _Browser_: 
    
    
    $client = new \Buzz\Client\Curl();
    $browser = new \Buzz\Browser($client);
    $response = $browser->get('http://www.google.com');

Po jakimś czasie zaobserwowaliśmy, że czas żądania często przekracza domyślny limit pięciu sekund. Zwiększamy go do piętnastu: 
    
    
    $client = new \Buzz\Client\Curl();
    $client->setTimeout(15);
    
    $browser = new \Buzz\Browser($client);
    $response = $browser->get('http://www.google.com');

Zauważmy, że modyfikacji musimy wprowadzić wszędzie, gdzie używany jest Buzz. Taki kod szybko staje się zagmatwany i trudny w utrzymaniu. Wprawdzie do konstrukcji obiektu _Browser_ moglibyśmy użyć fabryki, jednak pisanie takiej klasy dla każdej z naszych usług jest powtarzalną czynnością. Nie bylibyśmy [DRY](http://en.wikipedia.org/wiki/Don't_repeat_yourself) przez tworzenie wielu klas o podobnym przeznaczeniu. Innym rozwiązaniem jest **centralizacja tworzenia obiektów**. Właśnie za to odpowiedzialny jest kontener usług (DIC). 

## Tworzenie obiektów z DIC

Zamiast jawnie utworzyć obiekt klasy Browser, **powiemy kontenerowi usług jak to zrobić**: 
    
    
    <?php
    // dependencyinjection.php
    
    require_once __DIR__.'/src/autoload.php';
    
    use Symfony\Component\DependencyInjection\ContainerBuilder;
    use Symfony\Component\DependencyInjection\Definition;
    
    $serviceContainer = new ContainerBuilder();
    
    $browserDefinition = new Definition('Buzz\Browser');
    $serviceContainer->setDefinition('browser', $browserDefinition);

Następnie **zarządamy dostępu do usługi**: 
    
    
    $browser = $serviceContainer->get('browser');
    $response = $browser->get('http://www.google.com/');

Aby zastąpić domyślnego klienta HTTP, utworzymy definicję kolejnej usługi i przekażemy ją do poprzedniej jako referencję: 
    
    
    <?php
    // dependencyinjection.php
    
    // ...
    
    $serviceContainer = new ContainerBuilder();
    
    $clientDefinition = new Definition('Buzz\Client\Curl');
    $clientDefinition->addMethodCall('setTimeout', array(15));
    $serviceContainer->setDefinition('browser.client', $clientDefinition);
    
    $browserDefinition = new Definition('Buzz\Browser', array(new Reference('browser.client')));
    $serviceContainer->setDefinition('browser', $browserDefinition);

Zauważmy, że chociaż tworzenie obiektu się komplikuje, zarządzamy nim w jednym miejscu. Kod, który go używa pozostaje prosty: 
    
    
    $browser = $serviceContainer->get('browser');

Podczas, gdy definicja usługi się zmienia, kod, który ją konsumuje pozostaje nienaruszony. **Uwaga**: Oczywiście, obiekt nie zostanie utworzony, jeśli go nigdy nie pobierzemy z kontenera. 

## Opisywanie usług w XML

Usługi możemy opisywać w różnych formatach, nie tylko PHP. Komponent _DependencyInjection_ dostarcza nam narzędzia do zapisywania i ładowania definicji usług. Szczególnie kusząca jest perspektywa konfiguracji usług w formatach **Yaml** lub **XML**. W ten sposób **separacja** między konstrukcją obiektu, a jego konsumentem będzie bardziej widoczna. Poza tym definicje usług staną się **czytelniejsze**. Poniższy fragment kodu _XML_ opisuje te same usługi, które wcześniej zdefiniowaliśmy w PHP: 
    
    
    <?xml version="1.0" encoding="utf-8"?>
    <-- config/buzz.xml -->
    <container xmlns="http://symfony.com/schema/dic/services"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
               xsi:schemaLocation="http://symfony.com/schema/dic/services http://symfony.com/schema/dic/services/services-1.0.xsd">
      <services>
        <service id="browser.client" class="Buzz\Client\Curl">
          <call method="setTimeout">
            <argument>15</argument>
          </call>
        </service>
        <service id="browser" class="Buzz\Browser">
          <argument type="service" id="browser.client"/>
        </service>
      </services>
    </container>

Załadowanie usług do kontenera jest trywialne. Tworzymy _CotnainerBuilder_ i przekazujemy go do _XmlFileLoader_, który zajmie się  resztą: 
    
    
    <?php
    // dependencyinjectionloader.php
    
    require_once __DIR__.'/src/autoload.php';
    
    use Symfony\Component\DependencyInjection\ContainerBuilder;
    use Symfony\Component\DependencyInjection\Loader\XmlFileLoader;

## Comments

**[Str](#3074 "2011-09-15 01:59:51"):** Swietny artykul. Keep up the good work m8

