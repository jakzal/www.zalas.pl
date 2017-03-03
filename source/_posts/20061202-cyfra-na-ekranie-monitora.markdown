---
title: Cyfra+ na ekranie monitora
link: http://www.zalas.pl/cyfra-na-ekranie-monitora
author: admin
description: 
post_id: 9
created: 2006/12/02 23:13:32
created_gmt: 2006/12/02 22:13:32
comment_status: open
post_name: cyfra-na-ekranie-monitora
status: publish
post_type: post
---

<!--Cyfra+ jest obecnie jedyną platformą cyfrową umożliwiającą wykupienie abonamentu bez dodatkowych kosztów związanych z kupnem dekodera, czy anteny satelitarnej. O ile bez anteny się nie obejdziemy, to do oglądania tv-sat z użyciem komputera dekoder nie jest nam potrzebny. Wystarczy niskobudżetowa karta DVB-S (na przykład SkyStar2) i programator PHOENIX.-->

# Cyfra+ na ekranie monitora

[Cyfra+](http://www.cyfraplus.pl/) jest obecnie jedyną platformą cyfrową umożliwiającą wykupienie abonamentu bez dodatkowych kosztów związanych z kupnem dekodera, czy anteny satelitarnej. O ile bez anteny się nie obejdziemy, to do oglądania tv-sat z użyciem komputera dekoder nie jest nam potrzebny. Wystarczy niskobudżetowa karta [DVB-S](http://pl.wikipedia.org/wiki/Karta_dvb-s) (na przykład SkyStar2) i programator [PHOENIX](http://allegro.pl/search.php?string=phoenix&category=18). Temat ten jest rzadko opisywany w kontekście systemu Linux i jego początkujący użytkownicy mogliby pomyśleć, że jest to zadanie trudne do wykonania. Nic bardziej mylnego. Programator wystarczy podłącyć do portu COM i do źródła zasilania (niektóre wersje mają zasilanie z USB), po czym uruchomić [VDR](http://www.cadsoft.de/vdr/) z pluginem sc. Pluginowi trzeba przekazać opcję (-s) wskazującą nazwę pliku powiązanego z portem do którego został podpięty programator. Polecenie uruchamiające nasz zestaw powinno wyglądać conajmniej tak: ./vdr -P'sc -s /dev/ttyS0'. 

![Phoenix](/uploads/wp/2009/04/phoenix-300x249.png)

## Comments

**[bcfan](#2971 "2009-06-25 12:21:51"):** Właśnie mam zamiar coś takiego zrobić. Czy takie zestawienie działa na tych nowych kartach od Cyfry?

**[Kuba](#2974 "2009-06-30 10:16:07"):** Co znaczy nowych? Jakiś czas temu cyfra przyslała mi nową kartę i działa tak dobrze jak poprzednia. Nie wiem czy jest to ta 'nowa', o której wspominasz :)

**[Wojtek](#2986 "2010-03-05 11:05:17"):** Hej,Właśnie usiłuję uruchomić vdr z vdr-sc (z modułami libsc-sc_seca i libsc-seca). Wersja vdr 1.7.9, wersja sc 0.9.3 kompilowane ze zródeł. Do tego phoenix na ttyS0 i karta C+ z pakietem komfortowy. I niestety nie działa :(. Wykrywa kartę, poprawnie czyta klucze. Na kanałach na które nie mam uptrawnień wyświetla "No access, check your subscription (status: 93 02)". Natomiast przy próbie dostępu do kanału który powinien działac dostaję "No encryption system found".Jakieś sugestie? Mój system to Fedora 12.

