---
title: EpgDownloader
slug: epgdownloader
author: Jakub Zalas
description: 
post_id: 160
created: 2010/01/30 20:52:52
created_gmt: 2010/01/30 19:52:52
comment_status: open
post_name: epgdownloader
status: publish
layout: post
expired: true
comments: true
tags: [epgdownloader]
---

<!--EpgDownloader narodził się czerwcu 2005 roku jako prosty, perlowy skrypt. Parsował wtedy program telewizyjny wirtualnej polski i konwertował go do formatu akceptowanego przez VDR. Przyczyna jego powstania była bardzo prosta. Używałem VDR do oglądania telewizji satelitarnej, która w tamtym czasie nadawała EPG tylko na najbliższe dwie audycje. Nastawienie nagrywania w przyszłości stawało się uciążliwe, a zwykłe przejrzenie programu telewizyjnego niemożliwe. EpgDownloader pozwalał mi cieszyć się programem telewizyjnym w VDR na całe siedem dni naprzód.-->

# EpgDownloader

[EpgDownloader](http://epgdownloader.sourceforge.net/) narodził się czerwcu 2005 roku jako prosty, [perlowy](http://pl.wikipedia.org/wiki/Perl) skrypt. Parsował wtedy [program telewizyjny wirtualnej polski](http://tv.wp.pl/) i konwertował go do formatu akceptowanego przez [VDR](http://www.cadsoft.de/vdr/). Przyczyna jego powstania była bardzo prosta. Używałem VDR do oglądania telewizji satelitarnej, która w tamtym czasie nadawała [EPG](http://en.wikipedia.org/wiki/Electronic_program_guide) tylko na najbliższe dwie audycje. Nastawienie nagrywania w przyszłości stawało się uciążliwe, a zwykłe przejrzenie programu telewizyjnego niemożliwe. EpgDownloader pozwalał mi cieszyć się programem telewizyjnym w VDR na całe siedem dni naprzód. Ponieważ skrypt spełniał swoje zadanie wyśmienicie, postanowiłem się nim podzielić. Początkowo udostępniłem go na forum internetowym. Wkrótce po tym pojawiły się nowe pomysły. W marcu 2006 roku program zyskał budowę pluginową i został opublikowany na [SourceForge](https://sourceforge.net/)'u (wersja 0.6.4). Nie obyło się wtedy bez przepisania kodu. Dzięki temu mogłem szybko i przyjemnie tworzyć kolejne wtyczki w miarę potrzeb swoich i użytkowników. Z jednej strony było to wsparcie dla nowych stron z programem telewizyjnym, a z drugiej dla nowych formatów zapisu - takich jak [xmltv](http://wiki.xmltv.org/index.php/Main_Page). Dzięki xmltv program zyskał nowe grono użytkowników nie związanych z VDR, czy nawet telewizją satelitarną. Pomimo, że EpgDownloader istnieje od prawie pięciu lat, nie doczekał się jeszcze wydania 1.0. Program zawsze był rozwijany hobbistycznie, "po godzinach". Pisałem wtedy, kiedy naszła mnie ochota i czas na to pozwalał. Taka jest natura wielu aplikacji Open Source. Jednak pomimo rzadkiego zainteresowania z mojej strony do dzisiaj dostaję sporo maili od użytkowników. EpgDownloader wciąż cieszy się sporą popularnością. Bardzo dziękuję wszystkim, którzy przyczynili się w jakikolwiek sposów do powstawania i rozwoju EpgDownloader'a. Każdy tutaj jest bardzo ważny i nieistotne jest, czy napisał wtyczkę, maila, zgłosił poprawkę lub testował. W społeczności leży siła oprogramowania Open Source. **Ogromne podziękowania dla Was wszystkich!!!** Czekam na dalsze sugestie||skargi||pomysły||komentarze.

## Comments

**[Artur](#3067 "2011-08-29 05:59:39"):** Witam, Planujesz może zaktualizować plugin TelemanPl, bo z tego co zauważyłem, to wygląda strony teleman.pl się zmienił i plugin przestał działać... :(

**[Kuba](#3068 "2011-08-29 10:13:12"):** @Artur szczerze mówiąc dziwię się, że ludzie jeszcze tego używają. Projekt jest nie utrzymywany od dłuższego czasu (chociaż muszę przyznać, że dość rzadko się psuje). Nie planuję aktualizować pluginów, chyba, że cudownym sposobem zyskam nadmiar wolnego czasu ;)

**[Artur](#3069 "2011-08-30 00:00:17"):** @Kuba: dzięki za szybką odpowiedź. A jednak jeszcze ktoś korzysta :) po zamknięciu serwera tv.ubuntu.pl czy jakoś tak, gdzie były dostępne pliki xmltv.xml dla polskich stacji, sam sobie pobierałem wybrane stacje TV dzięki Twojemu skryptowi. Zobaczę, może sam się pokuszę na zmiany... Pozdrawiam i życzę nadmiaru wolnego czasu :P

**[Kuba](#3070 "2011-08-31 23:03:55"):** @Artur jeśli chcesz sam wprowadzać zmiany, to zrób forka na githubie. W ten sposób podzielisz się swoją pracą z innymi :) Szczegóły tutaj: http://www.zalas.pl/epgdownloader-przenosi-sie-na-gita

**[Radek](#3071 "2011-09-01 11:38:22"):** Korzysta, korzysta.Znajdź trochę tego czasu, co? (-:

**[Artur](#3072 "2011-09-05 01:50:02"):** https://github.com/tusek/EpgDownloader fork gotowy, że tak napiszę... u mnie działa :)

**[Kuba](#3073 "2011-09-05 05:53:01"):** @Artur świetnie! Dzięki :)

