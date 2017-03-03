---
title: Kompilacja programów QT4 w Windows
slug: kompilacja-programow-pisanych-z-uzyciem-qt4-w-windows
author: Jakub Zalas
description: 
post_id: 17
created: 2006/12/21 00:03:51
created_gmt: 2006/12/20 23:03:51
comment_status: open
post_name: kompilacja-programow-pisanych-z-uzyciem-qt4-w-windows
status: publish
layout: post
---

<!--Kompilacja programu napisanego w Qt wymaga oczywiście instalacji tej biblioteki. Trzeba będzie także zainstalować MinGW (Minimalist GNU for Windows). Na stronie Trolltech dostępny jest instalator, który pobierze i zainstaluje od razu oba pakiety.-->

# Kompilacja programów QT4 w Windows

Kompilacja programu napisanego w [Qt](http://www.trolltech.com/products/qt) wymaga oczywiście instalacji tej biblioteki. Trzeba będzie także zainstalować [MinGW](http://www.mingw.org/) (Minimalist GNU for Windows). Na stronie [Trolltech](http://www.trolltech.com) dostępny jest [instalator](http://www.trolltech.com/developer/downloads/qt/windows), który pobierze i zainstaluje od razu oba pakiety. Po instalacji trzeba zadbać o to, aby Windows 'widział' nowe narzędzia i biblioteki. Musimy dodać do odpowiednich ścieżek wyszukiwania katalogi lib, include i bin zarówno [Qt](http://www.trolltech.com/products/qt) jak i [MinGW](http://www.mingw.org/). W Windows 2000/Xp można to zrobić klikając 'Mój Komputer' -> 'System' -> 'Zaawansowane' -> 'Zmienne systemowe'. Kolejne ścieżki dopisujemy po średniku. Przed pierwszą kompilacją trzeba utworzyć plik Makefile za pomocą 'qmake' (będąc w katalogu ze źródłami programu). Po tym wywołujemy 'mingw-make' i uruchamiamy plik powstały w katalogu bin. Źródła: 

  1. <http://qtnode.net/wiki/Hello_World>
  2. <http://www.computerhope.com/issues/ch000549.htm>

## Comments

**[Gienek](#3004 "2010-08-13 10:58:07"):** Wszystko ładnie pięknie dopóki robimy na dynamicznych bibliotekach. Ja się już 2 dzień męczę żeby zrobić je statycznymi i żeby działało :\ może więc jakiś łopatologiczny przykład jak to zrobić??

**[Kuba](#3005 "2010-08-14 03:06:51"):** Niestety nie zajmowałem się kompilowanymi programami od czasu tego postu :)

