---
title: Instalacja PostgreSQL w Ubuntu 10.04
slug: instalacja-postgresql-w-ubuntu-1004
author: Jakub Zalas
description: 
post_id: 615
created: 2010/05/16 07:53:41
created_gmt: 2010/05/16 06:53:41
comment_status: open
post_name: instalacja-postgresql-w-ubuntu-1004
status: publish
layout: post
expired: true
comments: true
tags: [ubuntu,postgresql]
---

![PostgreSQL](/uploads/wp//2010/05/postgresql.png)[PostgreSQL](http://www.postgresql.org/) jest rozbudowanym i niezawodnym obiektowo-relacyjnym systemem baz danych. Stanowi doskonałą alternatywę dla popularnego MySQLa. PostgreSQL jest tak samo łatwy w obsłudze, sprawuje się lepiej i oferuje więcej. Instalacja PostgreSQL w Ubuntu sprowadza się do jednej komendy:
    
    
    sudo aptitude install postgresql

Użytkownicy bazy dancyh tworzeni są przy pomocy polecenia _createuser_. Uruchomienie poniższej komendy utworzy użytkownika 'kuba', który nie jest superużytkownikiem, może tworzyć bazy danych, nie może tworzyć nowych użytkowników, a jego hasło będzie przechowywane zaszyfrowane. Dzięki opcji '-P' będziemy zapytani o hasło: 
    
    
    sudo su postgres -c 'createuser -S -d -R -E -P kuba'

**Uwaga**: Uruchomienie _createuser_ z przełącznikiem _\--help_ wyświetli dostępne opcje. Bazy danych tworzymy podobnym narzędziem nazwanym _createdb_: 
    
    
    createdb moja_baza

**Uwaga**: O MySQL możecie przeczytać w moim innym poście: [Instalacja MySQL w Ubuntu 10.04](/instalacja-mysql-w-ubuntu-1004).
