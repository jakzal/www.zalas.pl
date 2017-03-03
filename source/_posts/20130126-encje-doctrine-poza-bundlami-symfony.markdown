---
title: Encje Doctrine poza bundlami Symfony
slug: encje-doctrine-poza-bundlami-symfony
author: Jakub Zalas
description: 
post_id: 1053
created: 2013/01/26 23:59:38
created_gmt: 2013/01/26 22:59:38
comment_status: open
post_name: encje-doctrine-poza-bundlami-symfony
status: publish
post_type: post
---

<!--DoctrineBundle i bridge odpowiadają za integracje Doctrine ORM z frameworkiem Symfony. Jedną z funkcjonalności jaką oferuje DoctrineBundle jest automatyczna rejestracja mapowań w bundlach.-->

# Encje Doctrine poza bundlami Symfony

![](/uploads/wp/2013/01/entities.png)[DoctrineBundle](https://github.com/doctrine/DoctrineBundle) i [bridge](https://github.com/symfony/symfony/tree/master/src/Symfony/Bridge/Doctrine) odpowiadają za integracje Doctrine ORM z frameworkiem Symfony. Jedną z funkcjonalności jaką oferuje _DoctrineBundle_ jest automatyczna rejestracja mapowań w bundlach. Dopóki stosujemy się do konwencji, tzn umieszczamy encje w katalogu _Entity_, czy też mapowania w _Resources/config/doctrine_, doctrine zauważy naszą konfigurację i ją automatycznie zarejestruje. Wszystko dzięki domyślnie włączonej (w standardowej dystrybucji Symfony) opcji [auto mapping](http://symfony.com/doc/current/reference/configuration/doctrine.html#configuration-overview). Jest to bardzo wygodne, bo nie musimy dużo robić, aby zacząć pracę z ORMem. 

Z drugiej strony czasem lepiej jest, gdy nasze encje nie są częścią bundla, ale leżą gdzieś w ogólnej przestrzeni nazw. Jest to często lepsze podejście, jeśli nasze encje używane są w wielu bundlach lub nawet projektach. Największą zaletą tej metody jest odseparowanie warstwy ORMa od Symfony. Wydzielając ją do katalogu poza bundlem tworzymy bibliotekę, która jest niezależna od Symfony i może być potencjalnie użyta w dowolnym projekcie PHP.

Najlepszym miejscem by [skonfigurować mapowanie](http://symfony.com/doc/current/reference/configuration/doctrine.html#mapping-configuration) jest plik _app/config/config.yml_: 
    
    
    doctrine:
        orm:
            # ...
            mappings:
                Acme:
                    type: annotation
                    is_bundle: false
                    dir: %kernel.root_dir%/../src/Acme/Entity
                    prefix: Acme\Entity
                    alias: Acme

W powyższym przykładzie użyliśmy adnotacji, stąd opcja _dir_ jest ścieżką do katalogu z encjami. W przypadku mapowania _xml_ czy _yml_ byłaby to ścieżka do katalogu z plikami _xml/yml_. _Prefix_ jest fragmentem przestrzeni nazw naszych encji i powinien być unikalny. Dzięki _aliasowi_ będziemy mogli odnosić się do encji przy pomocy krótszej notacji. Przykładowo zamiast: 
    
    
    $entityManager->getRepository('Acme\Entity\Invoice');

użylibyśmy: 
    
    
    $entityManager->getRepository('Acme:Invoice');

Oczywiście możemy zdefiniować tyle mapowań ile tylko potrzebujemy, co pozwala nam grupować encje w niezależne przestrzenie nazw oraz używać odmiennych metod mapowania: 
    
    
    doctrine:
        orm:
            # ...
            mappings:
                AcmeCustomer:
                    type: annotation
                    is_bundle: false
                    dir: %kernel.root_dir%/../src/Acme/Customer/Entity
                    prefix: Acme\Customer\Entity
                    alias: Customer
                AcmeCms:
                    type: yml
                    is_bundle: false
                    dir: %kernel.root_dir%/../src/Acme/Cms/Entity/config
                    prefix: Acme\Cms\Entity
                    alias: CMS
