title: Nauka Symfony2 przez pisanie testów jednostkowych
link: http://www.zalas.pl/nauka-symfony2-pisanie-testow-jednostkowych
author: admin
description: 
post_id: 789
created: 2011/03/24 16:11:02
created_gmt: 2011/03/24 15:11:02
comment_status: open
post_name: nauka-symfony2-pisanie-testow-jednostkowych
status: publish
post_type: post

<!--Podczas Hacking Day na Symfony Live postanowiłem spróbować sił i po raz pierwszy napisać kilka testów dla Symfony2. Już od jakiegoś czasu jestem niemal fanatykiem TDD, a ostatnio mocno interestuję się BDD. Testy jednostkowe z pewnością nie są mi obce. Nie podejrzewałem jednak, że pisanie testów dla istniejącego kodu może sprawić tyle radości.

Odkryłem też, że testowanie jest doskonałą metodą na naukę Symfony2.-->

# Nauka Symfony2 przez pisanie testów jednostkowych

![](/uploads/wp/2011/03/unit-testing.png) Podczas Hacking Day na [Symfony Live](/symfony-live-2011) postanowiłem spróbować sił i po raz pierwszy napisać kilka testów dla [Symfony2](http://symfony.com). Już od jakiegoś czasu jestem niemal fanatykiem TDD, a ostatnio mocno interestuję się BDD. Testy jednostkowe z pewnością nie są mi obce. Nie podejrzewałem jednak, że ich pisanie dla istniejącego kodu może sprawić tyle radości. Odkryłem też, że jest to doskonała metoda na naukę Symfony2. 

## Testuj i ucz się

Pisząc testy z pewnością wnosimy swój wkład w projekt. Poprawiamy jego jakość i wiarygodność. To, że przy okazji uczymy się, jest nieco mniej oczywiste. Udeżyło mnie to podczas próby pisania pierwszych testów. Zwyczajowo, jednej klasie w aplikacji odpowiada jedna klasa testowa. **Czytając test uczymy się jak używać klasy, której on dotyczy**. Poznajemy jej API. Z kolei wymagana do napisania testu analiza kodu samej klasy, wiele nam powie o wnętrznościach Symfony. Kodując później aplikacje będziemy mieli bardzo przyjemne uczucie, że rzeźbimy w frameworku, który znamy tak jakbyśmy sami go napisali. 

## Jak zacząć?

Na początek warto zapoznać się z podstawowymi zasadami. Dzięki [standardom kodowania](http://symfony.com/doc/2.0/contributing/code/standards.html) nauczymy się "mówić" tym samym językiem co inni programiści Symfony. Następnym przystankiem powinien być rozdział z dokumentacji o [tworzeniu łatek](http://symfony.com/doc/2.0/contributing/code/patches.html). Dowiemy się z niego jak odbywają się prace i jakich narzędzi będziemy potrzebować. Na koniec (dla formalności) powinniśmy przeczytać [jak uruchomić testy](http://symfony.com/doc/2.0/contributing/code/tests.html). Po lekturze powyższych artykułów będziemy w stanie sforkować [repozytorium Symfony na githubie](http://github.com/symfony/symfony), sklonować je lokalnie i oczywiście uruchomić testy: 
    
    
    phpunit

![](/uploads/wp/2011/03/phpunit-output-400x128.png)

## Analiza Pokrycia Kodu Testami

Poprzez analizę pokrycia kodu testami (Code Coverage) możemy wyłuskać, które fragmenty zostały wykonane podczas uruchomienia testów. PHPUnit potrafi wygenerować nam raport z pokrycia w _html_u: 
    
    
    phpunit --coverage-html=cov

![](/uploads/wp/2011/03/symfony2-test-coverage-400x114.png)

Z raportu dowiemy się, które klasy i metody zostały przetestowane a także, które linie zostały wykonane podczas uruchomienia testów (i ile razy). Tworzy to z raportu doskonałe narzędzie do lokalizacji nie przetestowanego kodu. 

![](/uploads/wp/2011/03/symfony2-class-test-coverage-400x104.png)

Niestety PHPUnit nie powie nam, czy wszystkie możliwe ściezki wykonania zostały przebyte. To musimy zrobić sami. Zauważyłem także, że aby otrzymać bardziej realny raport z pokrycia testami, powinniśmy wygenerować go dla odosobnionego komponentu.  Czasem jeden komponent jest używany przez inny i potrafi to sfałszować wyniki. **Fakt, że kod został wykonany podczas testów nie oznacza, że jego zachowanie zostało przez nie zweryfikowane.** **![](/uploads/wp/2011/03/symfony2-components-test-coverage-400x266.png) **