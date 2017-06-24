---
title: Cyfra+ na ekranie monitora
slug: cyfra-na-ekranie-monitora
author: Jakub Zalas
description: 
post_id: 9
created: 2006/12/02 23:13:32
created_gmt: 2006/12/02 22:13:32
comment_status: open
post_name: cyfra-na-ekranie-monitora
status: publish
layout: post
expired: true
comments: true
tags: [vdr]
---

[Cyfra+](http://www.cyfraplus.pl/) jest obecnie jedyną platformą cyfrową umożliwiającą wykupienie abonamentu bez dodatkowych kosztów związanych z kupnem dekodera, czy anteny satelitarnej. O ile bez anteny się nie obejdziemy, to do oglądania tv-sat z użyciem komputera dekoder nie jest nam potrzebny. Wystarczy niskobudżetowa karta [DVB-S](http://pl.wikipedia.org/wiki/Karta_dvb-s) (na przykład SkyStar2) i programator [PHOENIX](http://allegro.pl/search.php?string=phoenix&category=18). Temat ten jest rzadko opisywany w kontekście systemu Linux i jego początkujący użytkownicy mogliby pomyśleć, że jest to zadanie trudne do wykonania. Nic bardziej mylnego. Programator wystarczy podłącyć do portu COM i do źródła zasilania (niektóre wersje mają zasilanie z USB), po czym uruchomić [VDR](http://www.cadsoft.de/vdr/) z pluginem sc. Pluginowi trzeba przekazać opcję (-s) wskazującą nazwę pliku powiązanego z portem do którego został podpięty programator. Polecenie uruchamiające nasz zestaw powinno wyglądać conajmniej tak: ./vdr -P'sc -s /dev/ttyS0'.

![Phoenix](/uploads/wp/2009/04/phoenix-300x249.png)
