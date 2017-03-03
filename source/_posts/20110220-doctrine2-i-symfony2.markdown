title: Doctrine2 i Symfony2
link: http://www.zalas.pl/doctrine2-i-symfony2
author: admin
description: 
post_id: 724
created: 2011/02/20 12:01:10
created_gmt: 2011/02/20 11:01:10
comment_status: open
post_name: doctrine2-i-symfony2
status: publish
post_type: post

<!--Wciąż poznaję Symfony2. Nadszedł czas na wybranie i przetestowanie ORMa. Symfony2 jest wystarczająco elastyczne, aby współpracować z praktycznie dowolnym (nowoczesnym) PHPowym ORMem. Równocześnie dostajemy rozsądną domyślną opcję w postaci Doctrine2.-->

# Doctrine2 i Symfony2

![Symfony2 i Doctrine](/uploads/wp//2011/02/symfony2-doctrine-logos.png)Wciąż poznaję [Symfony2](http://symfony-reloaded.org/). Nadszedł czas na wybranie i przetestowanie** ORM**a. Symfony2 jest wystarczająco elastyczne, aby współpracować z praktycznie dowolnym (nowoczesnym) PHPowym ORMem. Równocześnie dostajemy rozsądną **domyślną opcję** w postaci [Doctrine2](http://www.doctrine-project.org/). Już dawno zrezygnowałem z Propela na rzecz Doctrine 1.2. Odkąd pojawiło się Doctrine 2.0, innych rozwiązań poważnie nie rozważam. Na dzień dzisiejszy Doctrine2 jest bezkonkurencyjny. Naukę zacząłem od zapisu i odczytu danych. **Uwaga**: Nie jest to tutorial, ale przegląd podstaw Doctrine2. Tutoriale możemy znaleźć w [dokumentacji Doctrine2](http://www.doctrine-project.org/docs/orm/2.0/en/#tutorials) i [Symfony2](http://docs.symfony-reloaded.org/guides/doctrine/orm/index.html). 

## Utrwalanie danych

W Doctrine1 mieliśmy dogodną możliwość definiowania mapowań obiektów na relacje w schemacie yml. Podobny mechanizm dostępny jest również w Doctrine2. Jest też coś lepszego. Co naprawdę podoba mi się w Doctrine2 to fakt, że możemy zapisać w bazie danych obiekt **dowolnej klasy** definiując **mapowanie** przy pomocy **anotacji**: 
    
    
    use Doctrine\ORM\Mapping as ORM;
    
    /**
     * @ORM\Entity
     * @ORM\Table(name="articles")
     */
    class Article
    {
        /**
         * @ORM\Id
         * @ORM\Column(type="integer")
         */
        private $id = null;
    
        /**
         * @ORM\Column(type="string", length="255")
         */
        private $title = null;
    
        /**
         * @ORM\Column(type="boolean", name="is_active")
         */
        private $isActive = false;
    }

Dzięki temu trzymamy klasę i mapowanie w jednym miejscu, zamiast w dwóch. Kolejną nowością jest to, że nie musimy już dziedziczyć po wspólnej klasie rekordu. Zauważmy, że klasa _Article_ nie dziedziczy po niczym. Oprócz anotacji nie ma w niej nic nadzwyczajnego. Ponieważ nasze obiekty są lekkie, ma to dość znaczący wypływ na **wydajność** i **pamięciożerność**. _Efektem ubocznym jest to, że podczas debugowania nie wyplujemy na ekran połowy frameworka przy zrzucania danych print_r() lub var_dump(). _ Ale gdzie się podziała metoda _save()_? Doctrine2 nie implementuje wzorca active record. Nie mamy save, delete, czy innych typowych dla tego wzorca metod. Odpowiedzialność za te operacje przekazana jest do menedżera encji (**Entity Manager**). W Symfony2 menedżer encji dostępny jest w DIC (**Dependency Injection Container**). Zapisanie encji sprowadza się do: 
    
    
    $article = new Article();
    $article->setTitle('Doctrine2 i Symfony2');
    
    $entityManager = $this->get('doctrine.orm.entity_manager');
    $entityManager->persist($article);
    $entityManager->flush();

Bardzo podoba mi się to, że pracujemy z prostymi obiektami (**POPO** - Plain Old PHP Objects). Nasze klasy wolne są od kodu odpowiedzialnego za zapisywanie ich instancji do bazy danych. 

## Pobieranie danych

Po zapisaniu danych miło byłoby je odzyskać ;) Doctrine2 kontynuuje koncepcje **DQL** i pomocnych "szukaczy" (**finder methods**): 
    
    
    $entityManager = $this->get('doctrine.orm.entity_manager');
    $article = $entityManager->find('Article', $id);

Zapytania wykonywane są przez menedżer encji. Za kulisami menedżer przekazuje wywołanie do obiektu repozytorium (wzorzec repository). Wszystko działa bez dodatkowych zabiegów, bo mamy do dyspozycji domyślną implementację repozytorium. Oczywiście możemy ją zmienić. Ponieważ nie lubię pisać zapytań bezpośrednio w kontrolerze, szukałem miejsca, gdzie byłoby im lepiej (czegoś podobnego do klas *Table z Doctrine1). Konwencją wydaje się być pisanie własnych klas repozytorium ([Custom Repositories](http://www.doctrine-project.org/docs/orm/2.0/en/reference/working-with-objects.html#custom-repositories) w dokumentacji Doctrine): 
    
    
    class ArticleRepository extends EntityRepository
    {
        public function getActiveArticles()
        {
            return $this->_em->createQuery('SELECT a FROM Article a WHERE a.isActive = ?', true)->getResult();
        }
    }

W encji musimy wskazać Doctrine klasę repozytorium, której chcemy użyć zamiast domyślnej: 
    
    
    use Doctrine\ORM\Mapping as ORM;
    
    /**
     * @ORM\Entity(repositoryClass="ArticleRepository")
     * @ORM\Table(name="articles")
     */
    class Article
    {
      // ...
    }

## Co dalej?

Będę kontynuował naukę Doctrine2 podczas pracy  nad projektem w Symfony2. Jest jeszcze sporo ciekawych zagadnień, które znam bardzo pobieżnie (takie jak zdarzenia, walidatory, dziedziczenie). Poza tym Doctrine udostępnia sporą ilość anotacji, o których tu nie wspomniałem (jak [związki](http://www.doctrine-project.org/docs/orm/2.0/en/reference/association-mapping.html) pomiędzy obiektami).

## Comments

**[dominik](#3028 "2011-02-21 01:39:46"):** Też się przyglądam z ciekawości tym nowościom, ale dalej nie jestem przekonany co do tego czy to taka dobra droga. Po prostu dorabianie jakiejkolwiek funkcjonalności w komentarzach jest dla mnie brzydką sprawą. W javie jest tak samo, ale to o czymkolwiek nie świadczy. var_dumpować można zawsze konkretne dane, wtedy nie będzie miliona stron. Jedyny realnie ważny powód to te zasoby przy alokacji pamięci dla takich obiektów. W sumie to zobaczymy jak to się ułoży. Oby pojawiło się przynajmniej rozsądne wsparcie dla eclipse do tychże encji, przy generowanych klasach świetnie sobie z tym radził, a bez tego teraz to może być chwilami niewygodnie.

**[Kuba](#3029 "2011-02-21 03:41:32"):** @Dominik nie musisz korzystać z anotacji. "Stary" sposób nadal działa. Moim zdaniem anotacje to bardzo eleganckie rozwiązanie. Metaprogramowanie ograniczaja ilość kodu, którą musisz napisać, a co za tym idzie ograniczaja ilość błędów.

**[dominik](#3030 "2011-02-22 01:55:51"):** Problem z adnotacjami polega na tym, że składniowo nie jest to POHO, więc póki edytory się tego nie nauczą to będzie zwykły komentarz. Jak popsujesz w metodzie czy zmiennej coś to o ile nie ma za wiele magiczności to dostaniesz błąd, który boli od razu. Takie adnotacje zostaną komentarzem. No ale jak wspominałem - trzeba się z tym oswoić, zobaczymy jak się będzie to sprawować, bo to "szemrane" połączenie może fajnie działać ;)

**[xis](#3031 "2011-02-23 23:21:01"):** YMLe w tej chwili też nie są takie łatwe do "wciągnięcia" dla edytorów (brak jakiegoś odpowiednika DTD), więc kwestia konfiguracji upraszcza się w tej kwestii, że mapowanie jest w tym samym miejscu co klasa. Doctrine2 jak dla mnie wygląda super, bardzo przypomina Hibernate, którego bardzo lubię :)

**[json burn](#3032 "2011-03-01 12:11:37"):** Bardzo interesująca w D2 jest też obsługa mongoDB out of the box. Nie miałem okazji jeszcze korzystać z tej (quasi)bazy ale jak będę miał wbudowaną w ORM wygodną obsługę to na pewno się pokuszę.

**[Kuba](#3034 "2011-03-03 14:29:35"):** @json MongoDB jest częścią ODM (Object Document Mapper). Na oficjalne Doctrine2 składają się trzy komponenty: DBAL, ORM i ODM. Apropo ODM, to szykuje się też wsparcie dla CouchDB: https://github.com/doctrine/couchdb-odm

