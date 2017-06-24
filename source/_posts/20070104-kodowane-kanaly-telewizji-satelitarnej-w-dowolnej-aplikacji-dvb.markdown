---
title: Kodowane kanały telewizji satelitarnej w dowolnej aplikacji DVB
slug: kodowane-kanaly-telewizji-satelitarnej-w-dowolnej-aplikacji-dvb
author: Jakub Zalas
description: 
post_id: 22
created: 2007/01/04 00:46:11
created_gmt: 2007/01/03 23:46:11
comment_status: open
post_name: kodowane-kanaly-telewizji-satelitarnej-w-dowolnej-aplikacji-dvb
status: publish
layout: post
expired: true
comments: true
tags: [sasc-ng]
---

[Sasc-ng](https://opensvn.csie.org/traccgi/sascng/wiki/SascIndex) jest programowym modułem warunkowego dostępu ([SoftCAM](http://en.wikipedia.org/wiki/Conditional_access_module)) nowej generacji, przeznaczonym dla systemów linuksowych. Pozwala na oglądanie kodowanych kanałów za pomocą dowolnej aplikacji, posiadającej wsparcie dla [DVB](http://pl.wikipedia.org/wiki/DVB), bez modyfikacji jej kodu źródłowego. Dekrypcja odbywa się w tle i jest przezroczysta dla programu [DVB](http://pl.wikipedia.org/wiki/DVB), który traktuje wszystkie kanały jak [FTA](http://pl.wikipedia.org/wiki/FTA). **Uwaga**: Poniższy opis jest dosyć stary. Aktualniejsze informacje znajdziecie w poście "[Instalacja sasc-ng w Ubuntu 10.10](/instalacja-sasc-ng-ubuntu-1010)". Źródła [sasc-ng](https://opensvn.csie.org/traccgi/sascng/wiki/SascIndex) zawierają [moduł jądra](http://en.wikipedia.org/wiki/Loadable_Kernel_Module) (dvbloopback), który odpowiada za utworzenie wirtualnego adaptera [DVB](http://pl.wikipedia.org/wiki/DVB). Program [sasc-ng](https://opensvn.csie.org/traccgi/sascng/wiki/SascIndex) jest mostem pomiędzy wirtualnym, a prawdziwym urządzeniem. Wszystkie żądania przekazywane są do karty [DVB](http://pl.wikipedia.org/wiki/DVB), a wyniki wysyłane są spowrotem do wirtualnego urządzenia. Jeżeli zostanie wykryty kanał kodowany, strumień jest najpierw przepuszczany przez sc lub FFdecsa w celu dekrypcji (sasc opakowuje sc, aby działoo niezależnie i bez użycia [VDR](http://www.cadsoft.de/vdr/)). W ten sposób na wirtualny adapter wysyłane są tylko czyste dane. Aplikacje [DVB](http://pl.wikipedia.org/wiki/DVB) powinny korzystać właśnie z tego urządzenia. [Sasc-ng](https://opensvn.csie.org/traccgi/sascng/wiki/SascIndex) można pobrać z repozytorium [svn](https://opensvn.csie.org/traccgi/sascng/browser). Instalacja sprowadza się do kompilacji programu i modułu jądra. W katalogu sc_files powinny znaleźć się pliki związane z sc (utworzyłem linki symboliczne do tych używanych z [VDR](http://www.cadsoft.de/vdr/)).
    
    
    ~/ $ svn co http://OpenSVN.csie.org/sascng sasc-ng
    ~/ $ cd sasc-ng/
    ~/sasc-ng $ export DEFAULT_PORT='"/dev/ttyS0",0,0,0'
    ~/sasc-ng $ make
    ~/sasc-ng $ make module
    ~/sasc-ng $ ln -s /video/plugins/* ./sc_files/

Eksport zmiennej DEFAULT_PORT ma na celu ustalenie domyślnie używanego przez sc interfejsu smartcard (w tym przypadku podpięty pod COM1 programator [PHOENIX](http://www.jakub.zalas.net/2006/12/02/cyfra-na-ekranie-monitora/)). Po kompilacji trzeba załadować moduł‚ i uruchomić [sasc-ng](https://opensvn.csie.org/traccgi/sascng/wiki/SascIndex). Obie operacje muszą być wykonane z uprawnieniami użytkownika [root](http://pl.wikipedia.org/wiki/Root). 
    
    
    ~/sasc-ng % insmod dvbloopback.ko
    ~/sasc-ng % ./sasc-ng -j 0:1

Opcja '-j 0:1' wskazuje na numery odpowiednio prawdziwego (0) i wirtualnego urządzenia (1). Wszystkie aplikacje, które mają korzystać z [sasc-ng](https://opensvn.csie.org/traccgi/sascng/wiki/SascIndex) muszą używać urządzenia wirtualnego. Dodatkowo wszystkie kanały powinny być oznaczone jako niekodowane. Od tej pory to [sasc-ng](https://opensvn.csie.org/traccgi/sascng/wiki/SascIndex) będzie odpowiedzialne za dekrypcję, a aplikacji [DVB](http://pl.wikipedia.org/wiki/DVB) to w ogóle nie będzie obchodzić. Do oglądania telewizji możemy użyć nawet zwykłego mplayera: 
    
    
    ~/ $ mplayer -dvbin card=2 dvb://"TVN"

W przypadku VDR dobrze jest wybrać w '_Ustawienia_' -> _'DVB_' -> '_Aktualizuj kanały_' opcje **inne niż** '_Nazwy i PIDy_', czy '_Tylko PIDy_'. W przeciwnym razie [VDR](http://www.cadsoft.de/vdr/) oznaczy nam odpowiednie kanały jako kodowane i przy próbie ich nastawienia wyświetli komunikat '_Kanał niedostępny_'. W pliku [channels.conf](http://www.vdr-wiki.de/wiki/index.php/Channels.conf) trzeba zmienić [CAID](http://www.vdr-wiki.de/wiki/index.php/Channels.conf#CAID) każdego z kanałów na 0. [VDR](http://www.cadsoft.de/vdr/) należy uruchomić z opcją -D, wskazującą na urządzenie wirtualne. Pomysł jest na prawdę dobry, jednak prace nad implementacją nadal trwają. Kod jest wysoce eksperymentalny, często mało elegancki i pełny błędów. Lista możliwości zmienia się z każdym dniem, dlatego po więcej szczegółów najlepiej udać się na stronę [wiki](https://opensvn.csie.org/traccgi/sascng/wiki/SascIndex) projektu i forum [dvbn](http://dvbn.happysat.org/viewtopic.php?t=38235). Strona [wiki](https://opensvn.csie.org/traccgi/sascng/wiki/SascIndex) stanowi systematycznie uzupełniananą dokumentację, a na [forum](http://dvbn.happysat.org/viewtopic.php?t=38235) można znaleźć najświeższe informacje dotyczące programu oraz rozwiązania na potencjalnie napotkane problemy.
