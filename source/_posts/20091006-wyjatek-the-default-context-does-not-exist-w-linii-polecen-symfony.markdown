---
title: Wyjątek 'The "default" context does not exist.' w linii poleceń symfony
slug: wyjatek-the-default-context-does-not-exist-w-linii-polecen-symfony
author: Jakub Zalas
description: 
post_id: 322
created: 2009/10/06 22:40:47
created_gmt: 2009/10/06 21:40:47
comment_status: open
post_name: wyjatek-the-default-context-does-not-exist-w-linii-polecen-symfony
status: publish
layout: post
---

<!--Jeśli w taskach symfony spróbujemy użyć kontekstu poprzez wywołanie sfContext::getInstance(), otrzymamy wyjątek klasy sfException z komunikatem 'The "default" context does not exist'. Klasa sfContext reprezentuje kontekst aplikacji i dlatego nie jest on inicjowany w linii poleceń. Dobrą praktyką jest NIE używanie sfContext::getInstance(). Zdarza się niestety, że nie mamy innego wyboru (np. gdy korzystamy z obcego pluginu).-->

# Wyjątek 'The "default" context does not exist.' w linii poleceń symfony

Jeśli w taskach symfony spróbujemy użyć kontekstu poprzez wywołanie _sfContext::getInstance()_, otrzymamy wyjątek klasy _sfException_ z komunikatem '_The "default" context does not exist'._ Klasa _sfContext_ reprezentuje **kontekst aplikacji** i dlatego nie jest on inicjowany w linii poleceń. **Dobrą praktyką jest NIE używanie _sfContext::getInstance()._** Zdarza się niestety, że nie mamy innego wyboru (np. gdy korzystamy z obcego pluginu). 

![Default context does not exist](/uploads/wp//2009/10/task-default-context-exception.png)

## Inicjalizacja kontekstu

Aby pozbyć się wyjątku musimy zainicjalizować kontekst przy pomocy _sfContext::createInstance()_. Będziemy do tego potrzebować konfiguracji aplikacji, czyli obiektu klasy _sfApplicationConfiguration_. Symfony automatycznie go utworzy, jeśli przekażemy do taska opcję z nazwą aplikacji (na przykład _\--application=frontend_). 
    
    
    class toolsDosomethingTask extends sfBaseTask
    {
      protected function configure()
      {
        $this->addOptions(array(
          new sfCommandOption('application', null, sfCommandOption::PARAMETER_REQUIRED, 'The application name'),
          new sfCommandOption('env', null, sfCommandOption::PARAMETER_REQUIRED, 'The environment', 'dev'),
          new sfCommandOption('connection', null, sfCommandOption::PARAMETER_REQUIRED, 'The connection name', 'propel')
        ));
    
        $this->namespace        = 'tools';
        $this->name             = 'do-something';
        $this->briefDescription = '';
        $this->detailedDescription = '';
      }
    
      protected function execute($arguments = array(), $options = array())
      {
        if ($this->configuration instanceof sfApplicationConfiguration)
        {
          sfContext::createInstance($this->configuration);
        }
    
        if (sfContext::hasInstance())
        {
          $context = sfContext::getInstance();
        }
      }
    }

Jeśli nie podamy nazwy aplikacji, właśność _$this->configuration_ będzie obiektem klasy _ProjectConfiguration_. Z tego powodu przed wywołaniem _sfContext::createInstance()_ powinniśmy upewnić się, że pracujemy z konfiguracją aplikacji (na przykład przy pomocy [instanceof](http://php.net/instanceof)). Z kolei przed odwołaniem się do kontekstu dobrze jest sprawdzić metodą _sfContext::hasInstance()_, czy został wcześniej utworzony. 

## Wartość domyślna

Gdy zależy nam, aby konfiguracja aplikacji zawsze była obecna, możemy ustalić domyślną nazwę aplikacji: 
    
    
    new sfCommandOption('application', null, sfCommandOption::PARAMETER_REQUIRED, 'The application name', 'frontend')

Dzięki temu nie będzie konieczne wpisywanie jej w linii poleceń. 

## sfContext::getInstance() to zło

Jak zaznaczyłem we wstępie dobrą praktyką jest unikanie bezpośredniego odwoływania się do kontekstu. Bywa to trudne, ale należy mieć na uwadze, że używając singletona wiążemy klasy problematyczną zależnością. Dobre argumenty popierające tą tezę przedstawiono w artykule "[Why sfContext::getInstance() Is Bad](http://webmozarts.com/2009/07/01/why-sfcontextgetinstance-is-bad/)" i prezentacji "[30 Symfony Best Practices (slajd 58)](http://www.slideshare.net/nperriault/30-symfony-best-practices)".

## Comments

**[Shapha](#2980 "2009-12-03 05:20:47"):** Dzieki za artykul. Wreszcie moj task w cronie zaczal normalnie dzialac, nie musialem nic robic "na okolo" ;)

**[chris](#3092 "2013-01-08 08:22:00"):** zdarza się, nie zdaża

**[Kuba](#3093 "2013-01-11 05:34:22"):** @chris dzieki

