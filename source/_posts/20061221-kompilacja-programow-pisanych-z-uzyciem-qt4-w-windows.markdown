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
expired: true
comments: true
tags: [qt]
---

Kompilacja programu napisanego w [Qt](http://www.trolltech.com/products/qt) wymaga oczywiście instalacji tej biblioteki. Trzeba będzie także zainstalować [MinGW](http://www.mingw.org/) (Minimalist GNU for Windows). Na stronie [Trolltech](http://www.trolltech.com) dostępny jest [instalator](http://www.trolltech.com/developer/downloads/qt/windows), który pobierze i zainstaluje od razu oba pakiety. Po instalacji trzeba zadbać o to, aby Windows 'widział' nowe narzędzia i biblioteki. Musimy dodać do odpowiednich ścieżek wyszukiwania katalogi lib, include i bin zarówno [Qt](http://www.trolltech.com/products/qt) jak i [MinGW](http://www.mingw.org/). W Windows 2000/Xp można to zrobić klikając 'Mój Komputer' -> 'System' -> 'Zaawansowane' -> 'Zmienne systemowe'. Kolejne ścieżki dopisujemy po średniku. Przed pierwszą kompilacją trzeba utworzyć plik Makefile za pomocą 'qmake' (będąc w katalogu ze źródłami programu). Po tym wywołujemy 'mingw-make' i uruchamiamy plik powstały w katalogu bin. Źródła:

  1. <http://qtnode.net/wiki/Hello_World>
  2. <http://www.computerhope.com/issues/ch000549.htm>
