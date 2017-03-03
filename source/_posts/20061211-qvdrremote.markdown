---
title: QVdrRemote
slug: qvdrremote
author: Jakub Zalas
description: 
post_id: 12
created: 2006/12/11 01:53:11
created_gmt: 2006/12/11 00:53:11
comment_status: open
post_name: qvdrremote
status: publish
layout: post
---

<!--Steruję VDR za pomocą pilota PCMAK, podłączanego do portu COM. Musiałem poświęcić ten port dla programatora PHOENIX, aby legalnie korzystać z karty cyfry+. Pojawił się problem z dostępem do VDR. Jest on tak zaprojektowany, że umożliwia sterowanie z użyciem klawiatury, jednak nie jest to wygodne. Można oczywiście użyć xine, jednak nigdy nie lubiłem tego rozwiązania (przypisane VDR klawisze kłóciły się z tymi z xine). Na szczęście do VDR można wysyłać komendy z użyciem SVDRP (Simple Video Disk Recorder Protocol), dzięki czemu bardzo łatwo jest tworzyć aplikacje z nim współpracujące.-->

# QVdrRemote

![QVdrRemote Screenshot 2](/uploads/wp/2009/04/qvdrremote02-157x400.png) Steruję [VDR](http://www.cadsoft.de/vdr/) za pomocą pilota [PCMAK](http://www.pcmak.pl/), podłączanego do portu COM. Musiałem poświęcić ten port dla programatora [PHOENIX](http://www.jakub.zalas.net/PHOENIX), aby legalnie korzystać z karty [cyfry+](http://www.cyfraplus.pl/). Pojawił się problem z dostępem do [VDR](http://www.cadsoft.de/vdr/). Jest on tak zaprojektowany, że umożliwia sterowanie z użyciem klawiatury, jednak nie jest to wygodne. Można oczywiście użyć [xine](http://xinehq.de/), jednak nigdy nie lubiłem tego rozwiązania (przypisane [VDR](http://www.cadsoft.de/vdr/) klawisze kłóciły się z tymi z [xine](http://xinehq.de/)). Na szczęście do [VDR](http://www.cadsoft.de/vdr/) można wysyłać komendy z użyciem [SVDRP](http://www.linuxtv.org/vdrwiki/index.php/Svdrp) (Simple Video Disk Recorder Protocol), dzięki czemu bardzo łatwo jest tworzyć aplikacje z nim współpracujące. W ciągu godziny napisałem QVdrRemote, który w swojej pierwszej wersji może zastąpić pilota sterującego [VDR](http://www.cadsoft.de/vdr/). Potraktowałem to jako ćwiczenie z użycia biblioteki [QT](http://www.trolltech.com/products/qt) i w przyszłości mam zamiar go rozwinąć o dodatkowe funkcjonalności (np przeglądanie [EPG](http://en.wikipedia.org/wiki/Electronic_program_guide), programowanie nagrań itp). Program dokuje się w tacce systemowej, do czego używa klasy [QSystemTrayIcon](http://doc.trolltech.com/4.2/qsystemtrayicon.html) (dostępna dopiero w [QT](http://www.trolltech.com/products/qt)>=4.2). Działanie QVdrRemote jest bardzo proste. Kliknięcie przycisku powoduje wysłanie odpowiedniej komendy do [VDR](http://www.cadsoft.de/vdr/) poprzez gniazdo TCP. Nazwa hosta i port są definiowane jako makra preprocesora (w kolejnej wersji powinno się to odbywać z użyciem pliku konfiguracyjnego). Zmiana tych definicji powinna umożliwić sterowanie [VDR](http://www.cadsoft.de/vdr/) ze zdalnego komputera. 

Pobierz: [QVdrRemote-0.1](/uploads/wp/2009/04/qvdrremote-0.1.tgz) ![QVdrRemote Screenshot 1](http://www.zalas.pl/uploads/wp/2009/04/qvdrremote01-300x240.png) [dodano 20.12.2006] Dopisałem możliwość zmiany portu i hosta [VDR](http://www.cadsoft.de/vdr/). Program udało się skompilować w Windows i FreeBSD. 

Pobierz: [QVdrRemote-0.2](/uploads/wp/2009/04/qvdrremote-0.2.tgz) ![QVdrRemote w Windows](http://www.zalas.pl/uploads/wp/2009/04/qvdrremote_win2-400x300.png)
