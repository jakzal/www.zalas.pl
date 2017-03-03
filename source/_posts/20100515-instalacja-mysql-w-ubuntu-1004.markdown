---
title: Instalacja MySQL w Ubuntu 10.04
link: http://www.zalas.pl/instalacja-mysql-w-ubuntu-1004
author: admin
description: 
post_id: 611
created: 2010/05/15 23:29:30
created_gmt: 2010/05/15 22:29:30
comment_status: open
post_name: instalacja-mysql-w-ubuntu-1004
status: publish
post_type: post
---

<!--MySQL to jednen z popularniejszych relacyjnych systemów baz danych, który jest szeroko stosowany przy budowie aplikacji PHP. Jest dość łatwy w konfiguracji i obsłudze. Oto krótki opis instalacji MySQL w najnowszej wersji Ubuntu. -->

# Instalacja MySQL w Ubuntu 10.04

![MySQL](/uploads/wp//2010/05/logo-mysql-110x57.png)[MySQL](http://www.mysql.com/) to jednen z popularniejszych relacyjnych systemów baz danych, który jest szeroko stosowany przy budowie aplikacji PHP. Jest dość łatwy w konfiguracji i obsłudze. Oto krótki opis instalacji MySQL w najnowszej wersji Ubuntu. Serwer MySQL instalujemy krótkim poleceniem: 
    
    
    sudo aptitude install mysql-server

Instalator zapyta nas o hasło dla użytkownika root. Jest to konto administracyjne, dlatego używanie go do łączenia z MySQL w aplikacjach nie jest najlepszą praktyką. Dużo lepiej jest nadać sobie prawa do połączeń i tworzenia baz danych. Najpierw otwieramy konsolę MySQL: 
    
    
    mysql -p -u root

Następnie nadajemy sobie wszystkie przywileje do połączeń lokalnych: 
    
    
    GRANT ALL PRIVILEGES ON *.* TO kuba@'localhost' IDENTIFIED BY 'my$ecret';
    \q

Teraz możemy tworzyć bazy danych bez konta administracyjnego: 
    
    
    mysqladmin -p create wordpress

**Uwaga**: O instalacji PostgreSQL, alternatywy dla MySQLa, możecie przeczytać w moim kolejnym poście: [Instalacja PostgreSQL w Ubuntu 10.04](/instalacja-postgresql-w-ubuntu-1004).

## Comments

**[leppakaklifoth](#3087 "2012-03-06 09:51:56"):** Świetny post.

**[Marcin](#3094 "2014-06-06 00:20:30"):** Krótko. Rzeczowo. Dzięki Wielkie!

