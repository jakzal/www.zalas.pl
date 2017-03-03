---
title: Chromium, czyli Google Chrome w Ubuntu 9.10 (Karmic Koala)
slug: chromium-czyli-google-chrome-w-ubuntu-910-karmic-koala
author: Jakub Zalas
description: 
post_id: 389
created: 2009/10/31 14:35:16
created_gmt: 2009/10/31 13:35:16
comment_status: open
post_name: chromium-czyli-google-chrome-w-ubuntu-910-karmic-koala
status: publish
layout: post
---

<!--Google Chrome nie jest jeszcze dostępny pod Linuksem. Jest za to Chromium, czyli przeglądarka Open Source na bazie której zbudowany jest Chrome. Właściwe to obie aplikacje odróżnia tylko logo.-->

# Chromium, czyli Google Chrome w Ubuntu 9.10 (Karmic Koala)

[Google Chrome](http://www.google.com/chrome) nie jest jeszcze dostępny pod Linuksem. Jest za to [Chromium](http://www.chromium.org/), czyli przeglądarka Open Source na bazie której zbudowany jest Chrome. Właściwe to obie aplikacje odróżnia tylko logo. ![Chromium - Google Chrome w Ubuntu 9.10 \(Karmic Koala\)](/uploads/wp//2009/10/chromium-400x284.png) W [repozytoriach launchpad](https://launchpad.net/chromium-browser) dostępne są [codzinnie budowane pakiety Chromium](https://edge.launchpad.net/~chromium-daily/+archive/ppa). Proces jest automatyczny, więc nie są one przetestowane i bywa, że są zepsute. Używałem ich jednak jeszcze w Ubuntu 9.04 i nie napotkałem na żadne poważne problemy. Ponieważ w **Ubuntu 9.10** proces instalacji stał się nawet prostszy, zachęcam do testów. W **Karmic Koala** nie musimy więcej edytować pliku _/etc/apt/sources.list_, aby dodać nowe źródła. Teraz wystarczy wykonać jedno polecenie: 
    
    
    sudo add-apt-repository ppa:chromium-daily

Repozytoria zostaną dodane wraz z odpowiednimi kluczami GPG za nas. Teraz tylko odświeżamy bazę danych o pakietach i instalujemy przeglądarkę: 
    
    
    sudo aptitude update
    sudo aptitude install chromium-browser

Nie musimy już wykonywać dodatkowych czynności, aby dodać obsługę flash.

## Comments

**[Czarek](#2982 "2009-12-28 03:07:03"):** a dodanie klucza ?

**[Jakub Zalas](#2983 "2010-01-02 03:00:54"):** Jawne dodanie klucza nie jest konieczne. Polecenie add-apt-repository automatycznie dodaje klucz do repozytoriów launchpad.

**[Jakub Zalas](#2998 "2010-04-30 05:52:54"):** W Ubuntu 10.04 wystarczy zrobić 'sudo aptitude install chromium-browser'. Chromium jest w domyślnych repozytoriach Ubuntu :)

