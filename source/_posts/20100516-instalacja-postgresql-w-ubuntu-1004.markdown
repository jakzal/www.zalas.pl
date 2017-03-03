title: Instalacja PostgreSQL w Ubuntu 10.04
link: http://www.zalas.pl/instalacja-postgresql-w-ubuntu-1004
author: admin
description: 
post_id: 615
created: 2010/05/16 07:53:41
created_gmt: 2010/05/16 06:53:41
comment_status: open
post_name: instalacja-postgresql-w-ubuntu-1004
status: publish
post_type: post

<!--PostgreSQL jest rozbudowanym i niezawodnym obiektowo-relacyjnym systemem baz danych. Stanowi doskonałą alternatywę dla popularnego MySQLa. PostgreSQL jest tak samo łatwy w obsłudze, sprawuje się lepiej i oferuje więcej.-->

# Instalacja PostgreSQL w Ubuntu 10.04

![PostgreSQL](/uploads/wp//2010/05/postgresql.png)[PostgreSQL](http://www.postgresql.org/) jest rozbudowanym i niezawodnym obiektowo-relacyjnym systemem baz danych. Stanowi doskonałą alternatywę dla popularnego MySQLa. PostgreSQL jest tak samo łatwy w obsłudze, sprawuje się lepiej i oferuje więcej. Instalacja PostgreSQL w Ubuntu sprowadza się do jednej komendy: 
    
    
    sudo aptitude install postgresql

Użytkownicy bazy dancyh tworzeni są przy pomocy polecenia _createuser_. Uruchomienie poniższej komendy utworzy użytkownika 'kuba', który nie jest superużytkownikiem, może tworzyć bazy danych, nie może tworzyć nowych użytkowników, a jego hasło będzie przechowywane zaszyfrowane. Dzięki opcji '-P' będziemy zapytani o hasło: 
    
    
    sudo su postgres -c 'createuser -S -d -R -E -P kuba'

**Uwaga**: Uruchomienie _createuser_ z przełącznikiem _\--help_ wyświetli dostępne opcje. Bazy danych tworzymy podobnym narzędziem nazwanym _createdb_: 
    
    
    createdb moja_baza

**Uwaga**: O MySQL możecie przeczytać w moim innym poście: [Instalacja MySQL w Ubuntu 10.04](/instalacja-mysql-w-ubuntu-1004).

## Comments

**[leo](#3015 "2011-01-27 04:38:18"):** Aleś chłopie napisał, że hejcreatedb to w jakiej lokalizacji podaje ??

**[Kuba](#3016 "2011-01-28 07:32:10"):** Co createdb podaje? :)

**[Tomasz](#3022 "2011-02-13 23:31:13"):** Bardzo pobieżny i nieciekawy artykuł. I niech sobie taki będzie, tylko dlatego tak wysoko jest w wynikach Goggle'a? Nie zasługuje na tak wysoką pozycję...

**[Kuba](#3025 "2011-02-14 08:29:05"):** @Tomasz dzięki za komentarz! Czego więcej oczekujesz od artykułu o procesie instalacji PostgreSQL w Ubuntu?

**[Iwo](#3082 "2012-01-17 07:42:11"):** Dzięki. Opis jak dla mnie w sam raz. Wpisałem - działa - cóż więcej można chcieć?@Tomasz - "pobieżność" to tutaj atut - opis jest idealny dla tych którzy chcą po prostu uruchomić bazę, bez zbędnego wdawania się w szczegóły - dla pozostałych pozostawiam studiowanie dokumentacji, lub czytanie jednej z miliona książek na ten temat. A ciekawy to może być "Władca Pierścieni" a nie opis instalacji postgresa :P

**[kuba](#3083 "2012-01-20 15:59:57"):** @Iwo dzięki! Lepiej bym tego nie ujał :D

**[niezadowolony](#3085 "2012-02-23 11:23:12"):** wlasnie szukam czegos ciekawego o optymalizacji i konfiguracji postgresql (niestandardowej) i kolejne wpisy blogowe o tym jak uzyc "sudo aptitude install" powoli zaczynaja mnie irytowac..po co tworzyc takie artykuly?

**[Kuba](#3086 "2012-03-03 01:13:15"):** @niezadowolony popracuj nad doborem wlasciwych slow kluczowych, ktore wpisujesz do wyszukiwarki ;)

