---
title: Symfony Live Londyn 2012
link: http://www.zalas.pl/symfony-live-londyn-2012
author: admin
description: 
post_id: 1023
created: 2012/09/19 23:24:43
created_gmt: 2012/09/19 21:24:43
comment_status: open
post_name: symfony-live-londyn-2012
status: publish
post_type: post
---

<!--Świetne prezentacje, przyjaźni prelegenci i wspaniała społeczność. Pierwsza konferencja Symfony Live w Londynie okazała się dużym sukcesem. Cieszę się z tego podwójnie, jako że niedawno dołączyłem do ekipy Sensio Labs UK, organizatora konferencji ;)-->

# Symfony Live Londyn 2012

![](/uploads/wp/2012/09/sflive-london-2012.png)Świetne prezentacje, przyjaźni prelegenci i wspaniała społeczność. Pierwsza konferencja **[Symfony Live** w **Londynie**](http://london2012.live.symfony.com/) okazała się dużym sukcesem. Cieszę się z tego podwójnie, jako że niedawno dołączyłem do ekipy **[Sensio Labs UK**](http://www.sensiolabs.co.uk/), organizatora konferencji ;) Wysłuchaliśmy wielu ekscytujących prezentacji, wygłoszonych przez jednych z najlepszych prelegentów ze społeczności Symfony. Widać było, że coraz lepiej integrujemy się z programistami Drupala. Lider tego projektu podzielił się kilkoma sekretami na zbudowanie silnej społeczności. Muszę przyznać, że nieco nam jeszcze brakuje do Drupalowej paczki. Dla mnie jednak najważniejszym wydarzeniem była prezentacja [Marcello](https://twitter.com/_md) i [Konstantin](https://twitter.com/everzet)a na tamat "_Pełnego BDD w Symfony2_" (ang. "_Full Stack BDD in Symfony2_") i na tym skupię swoją relację. Jeśli nie jesteście zainteresowani BDD, pora przestać czytać... ...a może właśnie najwyższa pora zacząć interesować się tą metodyką! ![](/uploads/wp/2012/09/konstantin-and-marcello-400x400.jpeg)Chłopaki wystartowali z energetycznym wprowadzeniem do Behavior Driven Development (BDD), tłumacząć **dlaczego** warto stosować tą metodykę, omawiając zalety podejścia "**outside-in**" i udowadniając, że najlepszym sposobem na zapewnienie wysokiej **jakości** produktu jest podejście test-first (pisanie testów przed kodem produkcyjnym). Przypomnieli nam też jak ważne jest **nazewnictwo**. Terminologia jest główną przyczyną problemów i nieporozumień związanych z narzędziamy typu xUnit. Dlatego dobór słów i sposób w jaki komunikujemy się poprzez testy jest bardzo ważny. Tak, **komunikujemy!** Testy stanowią (zawsze aktualną) dokumentację naszego kodu i stąd powinny być czytelne. Czy uważacie testy napisane w PHPUnit za czytelne? Może, gdy już przebrniemy przez niekończące się ekrany wywołań definiujących moki... Czy potraficie bez problemu zrozumieć swój test napisany choćby tydzień temu? Niestety PHPUnit nie został zaprojektowany z myślą o pisaniu testów przed kodem. **Behat** doskonale sprawdza się w tzw **StoryBDD**. Niestety jak dotąd nie mieliśmy porządnego narzędzia działającego na poziomie **SpecBDD**. Pracując z Behatem i PHPUnit często jestem wybijany z rytmu, będąc zmuszany do zmiany kontekstu między tymi narzędziami.  Do niedawna nie rozumiałem dlaczego tak się dzieje. Dopóki nie uświadomiłem sobie, że PHPUnit jest niewłaściwym narzędziem do tego typu pracy (pomogła mi w tym lektura [RSpec book](http://pragprog.com/book/achbd/the-rspec-book)). Marcello i Konstantin doświadczyli tych samych problemów i postanowili im zaradzić. Stworzyli nową wersję PHPSpec (PHPSpec2), ktorą po raz pierwszy zaprezentowali światu na swojej prezentacji w Londynie. PHPSpec2 jest to alternatywą dla PHPUnit, lepiej dostosowaną do podejścia BDD, używającą lepszej terminologii. Zmiana kontekstu między Behatem a PHPSpec nie wybija z rytmu. PHPSpec idealnie uzupełnia Behata, pozwalając na sprawne pisanie czytelnych testów. Wracając do prezentacji... jej druga część skupiła się na tym jak zastosować teorię w praktyce. Chłopaki po raz pierwszy zaprezentowali **jak** powinien wyglądać pełny cykl **BDD** w **Symfony2** z punktu widzenia programisty. To było niesamowite 20 minut pokazujące jak można testami napędzać implementację nowej funkcjonalności, sprawnie przechodząc między Behatem (scenariuszami) i PHPSpec2 (specyfikacjami), płynnie powtarzając cykl dopóki funkcjonalność nie zostanie ukończona. Oba narzędzia praktycznie sugerowały kolejne kroki implementacji. Jestem pewien, że pokazując to na żywo, chłopaki przekonali nie jednego sceptyka. Udowodnili nie tylko, że podejście test-first wcale nie zajmuje więcej czasu, ale de-facto jest możliwe działać sprawniej niż "tradycyjnie" testując swój kod w przeglądarce. Mam nadzieję, że moja krótka relacja pogłębiła Wasze zainteresowanie BDD. Proponuję kontynuować czytając [wpis Konstantina, w którym podsumowuje swoją prezentację](http://everzet.com/post/31581124270/fullstack-bdd-2012-wrapup). Następnie warto prześledzić pełen cykl w [specjalnie do tego celu przygotowanym repozytorium](https://github.com/everzet/fullstack-bdd-sflive2012). Wytrwali mogą zajrzeć w kod [PHPSpec2](https://github.com/phpspec/phpspec2) (nad którym prace ciągle trwają). 

**Uwaga**: Ponieważ terminologia jest ważna, powinniśmy unikać słowa "test". Rozmawiając o "testach" dajemy do zrozumienia, że chcemy coś testować lub sprawdzać, podczas gdy w metodykach TDD/BDD nie o to chodzi. TDD jest czynnością bliższą projektowaniu niż testowaniu. Głównym zadaniem podczas rozwijania kodu z podejściem TDD jest projektowanie naszego kodu przy pomocy testów. Z powodu tych nieporozumień BDD redefiniuje "testy" jako "specyifkacje".

## Więcej o konferencji

Jak zwykle, feedback uczestników znajdziecie na [joind.in](https://joind.in/event/view/1000). Warto też przeczytać relacje innych: 

  * [Symfony2 Live! London – aftermatch](http://criticallog.thornet.net/2012/09/14/symfony2-live-london-aftermatch/)
  * [Symfony Live London 2012 recap](http://xlab.pl/symfony-live-london-2012-recap/)
  * [Symfony Live London – A Huge Success](http://www.sensiolabs.co.uk/blog/symfony-live-london-a-huge-success/)
  * [Fullstack BDD wrap up](http://everzet.com/post/31581124270/fullstack-bdd-2012-wrapup)

Na koniec, trochę zdjęć na [flickr](http://www.flickr.com/photos/sensiolabsuk/sets/72157631558775580/).

Do zobaczenia w [Berlinie na kolejnej Symfony Live](http://berlin2012.live.symfony.com/en/index.html)!

![](/uploads/wp/2012/09/polish-symfony-community-london-2012-400x300.jpg)
