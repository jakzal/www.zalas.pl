---
title: Tworzenie sparametryzowanych komend w PHP z komponentem Console Symfony2
slug: tworzenie-sparametryzowanych-komend-w-php-z-komponentem-console-symfony2
author: Jakub Zalas
description: 
post_id: 946
created: 2011/07/04 04:00:09
created_gmt: 2011/07/04 02:00:09
comment_status: open
post_name: tworzenie-sparametryzowanych-komend-w-php-z-komponentem-console-symfony2
status: publish
layout: post
tags:
- cli
- components
- Console
- php
- Symfony2
expired: true
comments: true
---

<!--Komponent Console Symfony2 ułatwia tworzenie sparametryzowanych komend w PHP. Odpowiada za niewdzięczną pracę parsowania wejścia i pisania na wyjście.-->

# Tworzenie sparametryzowanych komend w PHP z komponentem Console Symfony2

![](/uploads/wp/2011/07/console-150x150.png)[Komponent Console](https://github.com/symfony/Console) Symfony2 ułatwia tworzenie sparametryzowanych komend w PHP. Odpowiada za niewdzięczną pracę parsowania wejścia i pisania na wyjście. **Uwaga**: Kod tworzony w tym wpisie jest dostępny na githubie: <https://github.com/jakzal/SymfonyComponentsExamples>

## Instalacja

Komponent możemy zainstalować za pomocą [kanału PEAR Symfony2](http://pear.symfony.com/) lub go po prostu pobrać z [github](https://github.com/symfony/Console)a. Na potrzeby tego wpisu sklonujemy źródła do katalogu _vendor/_ naszego projektu. 
    
    
    git clone https://github.com/symfony/Console.git vendor/Symfony/Component/Console

Użyjemy ClassLoader, innego komponentu Symfony2, do automatycznego ładowania klas. Więcej o tym komponencie we wpisie  "[Automatyczne ładowanie klas w dowolnym projekcie PHP z komponentem ClassLoader Symfony2](/automatyczne-ladowanie-klas-w-dowolnym-projekcie-php-z-komponentem-classloader-symfony2)". Poniższy kod wystarczy, aby wszystkie klasy z dowolnego komponentu Symfony2 były automatycznie ładowane (zakładając, że komponenty są umieszczane w katalogu _vendor/Symfony/Component_): 
    
    
    <?php
    // src/autoload.php
    require_once __DIR__.'/../vendor/Symfony/Component/ClassLoader/UniversalClassLoader.php';
    
    $loader = new Symfony\Component\ClassLoader\UniversalClassLoader();
    $loader->registerNamespaces(array(
        'Symfony' => __DIR__.'/../vendor',
        'PSS'     => __DIR__
    ));
    $loader->register();

Przestrzeń nazw PSS posłuży naszym klasom. 

## Tworzenie aplikacji konsolowej

Aplikacja konsolowa pomoże nam zarządzać komendami: 
    
    
    <?php
    // console.php
    require_once __DIR__.'/src/autoload.php';
    
    use Symfony\Component\Console as Console;
    
    $application = new Console\Application('Demo', '1.0.0');
    $application->run();

Jeśli uruchomimy skrypt bez argumentów, zobaczymy przegląd domyślnych opcji i komend. 

![](/uploads/wp/2011/06/console-options-400x241.png)

Istnieją dwie wbudowane komendy: help i list. 

## Tworzenie komendy

Komendę tworzymy rozszerzając klasę Command i implementując w niej metodę _execute()_. 
    
    
    <?php
    // src/PSS/Command/HelloWorldCommand.php
    namespace PSS\Command;
    
    use Symfony\Component\Console as Console;
    
    class HelloWorldCommand extends Console\Command\Command
    {
        protected function execute(Console\Input\InputInterface $input, Console\Output\OutputInterface $output)
        {
            $output->writeln('Hello World!');
        }
    }

Metoda przyjmuje obiekty wejścia i wyjścia jako parametry (_$input_ i _$output_). Obiektu wejścia będziemy używać, aby dostać się do argumentów i opcji przekazanych do skryptu. Obiekt wyjścia jest pomocy przy drukowaniu komunikatów (np na ekran). Każda komenda musi być zarejestrowana w aplikacji: 
    
    
    <?php
    // console.php
    require_once __DIR__.'/src/autoload.php';
    
    use Symfony\Component\Console as Console;
    
    $application = new Console\Application('Demo', '1.0.0');
    **$application->add(new PSS\Command\HelloWorldCommand('hello-world'));**
    $application->run();

Skrypt przyjmuje nazwę komendy jako pierwszy argument . Naszą komendę wywołamy przez: 
    
    
    php console.php hello-world

W wyniku powinniśmy zobaczyć "Hello World!" wypisane na ekran. 

## Dodajemy argumenty i opcje

Argumentów i opcji możemy użyć, aby sparametryzować i zmienić zachowanie naszej komendy. Zmodyfikujemy komendę HelloWorld, aby przyjmowała imię jako parametr. Wydrukujemy je później na ekran. Dodamy też opcję "-_-more_", która sprawi, że komenda wypisze dodatkowy komunikat. Argumenty i opcje, które chcemy móc przekazywać do komendy, deklarujemy odpowiednio metodami _addArgument()_ i _addOption()_. Możemy uczynić je opcjonalnymi lub wymaganymi, dodać opis i wartości domyślne. Podane w linii poleceń parametry pobieramy po prostu z obiektu wejścia (_$input)_ przekazanego do metody _execute()_ (Aplikacja konsolowa zajmie się szczegółami). 
    
    
    <?php
    // src/PSS/Command/HelloWorldCommand.php
    namespace PSS\Command;
    
    use Symfony\Component\Console as Console;
    
    class HelloWorldCommand extends Console\Command\Command
    {
        public function __construct($name = null)
        {
            parent::__construct($name);
    
            $this->setDescription('Outputs welcome message');
            $this->setHelp('Outputs welcome message.');
            $this->addArgument('name', Console\Input\InputArgument::OPTIONAL, 'The name to output to the screen', 'World');
            $this->addOption('more', 'm', Console\Input\InputOption::VALUE_NONE, 'Tell me more');
        }
    
        protected function execute(Console\Input\InputInterface $input, Console\Output\OutputInterface $output)
        {
            $name = $input->getArgument('name');
    
            $output->writeln(sprintf('Hello %s!', $name));
    
            if ($input->getOption('more')) {
                $output->writeln('It is really nice to meet you!');
            }
        }
    }

Teraz możemy użyć nowo dodanego argumentu i opcji: 
    
    
    php console.php hello-world -m Kuba

Dodatkowe wywołania _setDescription()_ i _setHelp()_ w konstruktorze ustawiają opis komendy i komunikat pomocy. Są bardzo przydatne, gdy nasz skrypt ma być używany przez innych. Pomoc uzyskamy wywołując komendę _help_ z nazwą naszej komendy przekazaną jako argument: 
    
    
    php console.php help hello-world

![](/uploads/wp/2011/06/console-help-400x158.png)

## Interaktywna powłoka

Poprzez opakowanie aplikacji konsolowej obiektem klasy Shell, łatwo zyskamy funkcjonalność interaktywnej powłoki: 
    
    
    <?php
    // consoleshell.php
    require_once __DIR__.'/src/autoload.php';
    
    use Symfony\Component\Console as Console;
    
    $application = new Console\Application('Demo', '1.0.0');
    $application->add(new PSS\Command\HelloWorldCommand('hello-world'));
    
    $shell = new Console\Shell($application);
    $shell->run();

W ten sposób skrypt nie zakończy działania zaraz po uruchomieniu, ale będzie czekał na nasze komendy: 
    
    
    php consoleshell.php

![](/uploads/wp/2011/06/console-shell-363x400.png)
