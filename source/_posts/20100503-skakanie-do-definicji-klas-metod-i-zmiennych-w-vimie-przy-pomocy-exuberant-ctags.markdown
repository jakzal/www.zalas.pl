---
title: Skakanie do definicji klas, metod i zmiennych w vimie przy pomocy exuberant ctags
slug: skakanie-do-definicji-klas-metod-i-zmiennych-w-vimie-przy-pomocy-exuberant-ctags
author: Jakub Zalas
description: 
post_id: 599
created: 2010/05/03 07:46:42
created_gmt: 2010/05/03 06:46:42
comment_status: open
post_name: skakanie-do-definicji-klas-metod-i-zmiennych-w-vimie-przy-pomocy-exuberant-ctags
status: publish
layout: post
expired: true
comments: true
tags: [vim]
---

<!--Dzięki exuberant ctags możemy skakać do definicji klas, metod, zmiennych i innych konstrukcji językowych w vimie. Narzędzie potrafi wygenerować plik z indeksem słów kluczowych (tagów) dla jednego spośród 41 wspieranych języków programowania. Indeks ten jest używany w edytorach typu vim do szybkiego odnajdywania powiązanych słów kluczowych.-->

# Skakanie do definicji klas, metod i zmiennych w vimie przy pomocy exuberant ctags

Dzięki [exuberant ctags](http://ctags.sourceforge.net/) możemy skakać do definicji klas, metod, zmiennych i innych konstrukcji językowych w **vim**ie. Narzędzie potrafi wygenerować plik z indeksem słów kluczowych (tagów) dla jednego spośród [41 wspieranych języków programowania](http://ctags.sourceforge.net/languages.html). Indeks ten jest używany w edytorach typu vim do szybkiego odnajdywania powiązanych słów. 

## Instalacja

Instalacja nie powinna stanowić problemu na żadnym Linuksowym systemie. W Ubuntu pakiet **exuberant ctags** znajduje się w domyślnych repozytoriach. Do instalacji możemy użyć Centrum Oprogramowania Ubuntu lub otworzyć terminal i wpisać: 
    
    
    sudo aptitude install exuberant-ctags

## Generowanie indeksu

Zanim będziemy mogli korzystać z dobrodziejstw ctagów musimy wygenerować plik z indeksem. Użyjemy do tego komendy **ctags** (to alias dla ctags-exuberant). Aby wygenerować indeks najpierw musimy zmienić katalog roboczy na główny katalog projektu. Następnie rekrusywnie go indeksujemy: 
    
    
    cd ~/workspace/projects/sympal
    ctags -R --languages=php .

**Uwaga**: '_man ctags_' powie nam więcej o dostępnych opcjach. **Uwaga**: Dawno temu [Matthew Weier O'Phinney](http://twitter.com/weierophinney) opisał jak używać ctags z PHP: [exuberant ctags with PHP in vim](http://weierophinney.net/matthew/archives/134-exuberant-ctags- with-PHP-in-Vim.html). Użył kilku opcji, które nie wydają mi się już potrzebne. Prawdopodobnie wsparcie dla PHP zostało od tego czasu poprawione. 

## Podstawy

Podstawowe wykorzystanie tagów sprowadza się do dwóch komend: 

  * **ctrl-]** zabierze nas do deklaracji powiązanej ze słowem pod kursorem. Nie jest istotne w jakim pliku się ona znajduje. Słowo wrzucane jest także na stos tagów.
  * **ctrl-t** zabierze nas do poprzedniego tagu na stosie.
Zauważmy, że komendy można poprzedzić liczbą. Spowoduje to jej wielokrotne wykonanie. Okazuje się to szczególnie przydatne jeśli jeden tag występuje wielokrotnie w naszych źródłach, a my chcemy skoczyć do konkretnego wystąpienia (**2ctrl-]**). Od czasu do czasu będziemy też potrzebowali wrócić do któregoś z rzędu tagu wstecz (**4ctrl-t**). Możemy od razu otworzyć wybrany tag w vimie przy pomocy opcji **-t**: 
    
    
    vim -t sfGuardUser

## Zaawansowane techniki

Niektóre z komend operujących na **stosie tagów**: 

  * **pop** skacze na stosie wstecz
  * **tag** skacze na stosie naprzód
  * **tags** wyświetla stos tagów
Niektóre z komend **listy opasowań tagów**: 

  * **tselelect** wyświetla listę tagów, które pasują do podanego argumentu lub słowa pod kursorem
  * **g]** działa jak **ctrl-]**, ale pozwala wybrać numer wystąpienia słowa
  * **:tnext**, **:tprevious**, **:tfirst** i **:tlast** skaczą po występieniach słowa
Niektóre z komend **wyszukiwania**: 

  * **[i** i **]i** wyświetlają pierwszą linię zawierającą tag pod i za kursorem
  * **[I** i **]I** wyświetlają wszystkie linie zawierające tag pod i za kursorem
  * **[ ctrl-i** i **] ctr-i** skaczą do pierwszej linii zawierającej tag pod i za kursoerm
**Uwaga**: Wpisując w vimie **:help tags-and-searches** otrzymamy szczegółowy opis funkcjonalności oferowanych przez tagi. 

## Przydatne Strony

  * [Patching exuberant-ctags for better PHP5 support in vim](http://www.jejik.com/articles/2008/11/patching_exuberant-ctags_for_better_php5_support_in_vim/)
  * [exuberant ctags with PHP in Vim](http://weierophinney.net/matthew/archives/134-exuberant-ctags-with-PHP-in-Vim.html)

## Wideo
