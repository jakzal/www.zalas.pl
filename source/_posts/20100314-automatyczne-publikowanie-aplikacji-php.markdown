title: Automatyczne publikowanie aplikacji PHP
link: http://www.zalas.pl/automatyczne-publikowanie-aplikacji-php
author: admin
description: 
post_id: 499
created: 2010/03/14 02:33:46
created_gmt: 2010/03/14 01:33:46
comment_status: open
post_name: automatyczne-publikowanie-aplikacji-php
status: publish
post_type: post

<!--Aplikacje PHP publikowane są na serwery na wiele różnych sposobów (pisząc "publikacja" mam na myśli anglojęzyczne słowo "deploy"). Niektórzy używają w tym celu systemów kontroli wersji takich jak Subversion. Inni po prostu kopiują pliki przy pomocy FTP, SSH czy rsync. Jest tylko jeden problem ze wspomnianymi technikami. Wszystkie są podatne na błędy. Transfer plików to tylko niewielka część całego procesu publikacji, czy aktualizacji aplikacji PHP. Często potrzebna jest dodatkowa konfiguracja, czy uruchomienie skryptów migracyjnych.-->

# Automatyczne publikowanie aplikacji PHP

![Zębatki](/uploads/wp/2010/03/gears-400x400.png)Aplikacje PHP publikowane są na serwery na wiele różnych sposobów (pisząc "publikacja" mam na myśli anglojęzyczne słowo "deploy"). Niektórzy używają w tym celu systemów kontroli wersji takich jak Subversion. Inni po prostu kopiują pliki przy pomocy FTP, SSH czy rsync. Jest tylko jeden problem ze wspomnianymi technikami. **Wszystkie są podatne na błędy.** Transfer plików to tylko niewielka część całego procesu publikacji, czy aktualizacji aplikacji PHP. Często potrzebna jest dodatkowa konfiguracja, czy uruchomienie skryptów migracyjnych. 

## Ludzie popełniają błędy

Im bardziej aplikacja jest skomplikowana, tym większe prawdopodobieństwo, że popełnimy błąd podczas aktualizacji. Zmiana konfiguracji, uruchomienie skryptów, budowanie modelu i plików wsdl, migracja bazy danych, czyszczenie cache. **Jest wiele momentów, gdzie coś może pójść źle.** A [jeśli coś może pójść źle, to z pewnością pójdzie](http://pl.wikiquote.org/wiki/Prawa_Murphy'ego). Wiele razy miałem problemy przez to, że ktoś zmienił produkcyjną konfigurację i zatwierdził zmiany w repozytorium. Poza tym informacje takie jak hasła do bazy danych nie mogły być tam nawet przechowywane. Przeprowadzanie i sprawdzanie konfiguracji za każdym razem, gdy aktualizujemy aplikację nie należy do najprzyjemniejszych. Podobnie jest z innymi krokami procesu. Robiąc to ręcznie narażamy się na popełnienie błędu. **Publikowanie aplikacji wymaga zbyt dużo myślenia, które można zrobić wcześniej.**

## Automatyzacja jest powtarzalna

**Automatyzacja procesu czyni go powtarzalnym.** Pozwala to właściwie go przetestować przed prawdziwą publikacją tyle tylko razy ile uważamy za stosowne. Potem nie musimy więcej myśleć o krokach, które trzeba wykonać. Uruchamiamy skrypty i czekamy aż skończą. **Nie musimy myśleć o procesie.** Aplikacje różnią się między sobą i każda może wymagać nieco innych czynności podczas aktualizacji. Panowanie nad tym i pamiętanie o różnicach jest tym bardziej uciążliwe im więcej mamy projektów. 

## Proces żyje z projektem

Automatyzacja procesu **przenosi odpowiedzialność** jego opracowania i utrzymania **na zespół programistów**. To właśnie oni najlepiej wiedzą co i kiedy ma dziać się podczas aktualizacji. Gdy trzeba wprowadzić zmiany w procesie, programiści są zmuszeni uaktualnić skrypty. Proces nie jest już tylko w ich głowach, ale **żyje z projektem.** Nawet po roku od zakończenia prac, gdy trzeba wypuścić poprawkę, a nikt już nie pamięta aplikacji, aktualizacja nie będzie problemem. Dodatkowo, nowi czlonkowie zespołu mogą nauczyć się procesu po prostu czytając skrypty. 

## Narzędzia do publikacji

Istnieją gotowe rozwiązania Open Source, które pozwolą Wam zautomatyzować proces aktualizacji projektów PHP: 

  * [Apache Ant](http://ant.apache.org/)
  * [Capistrano](http://www.capify.org/)
  * [Fredistrano](http://code.google.com/p/fredistrano/)
  * [Maven](http://www.php-maven.org/)
  * [Phing](http://phing.info/)
Jak publikujecie swoje aplikacje? Czy Wasz proces jest już zautomatyzowany? 

Type the name of a command and press enter to execute it, or **help** for assistance.

## Comments

**[xis](#2991 "2010-03-15 03:31:29"):** Ja robię tak: \- na stacji roboczej robię commit do svn, \- na serwerze robię svn up i wszystko leci na beta.mojadomena.pl, \- testuję czy beta działa poprawnie, \- jak beta jest OK i wszystko się wgrało to robie rsync na produkcję. Metoda prosta i nawet działa, ale nie jest wolna od wad: brak możliwości wycofania w przypadku ewentualnego problemu, no i wciąć ręcznie trzeba się zajmować wgrywanie patchy do bazy danych. Ten Capistrano to naprawdę dobry pomysł, chętnie wypróbuję w wolnej chwili :)

**[Kuba](#2992 "2010-03-15 12:08:46"):** To tez jest pewna automatyzacja. Dopóki sam nad wszystkim panujesz, to nie zawsze jest sens zaprzegac capistrano :)

