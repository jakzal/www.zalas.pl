---
title: Jak nagrać makro w edytorze vim?
slug: jak-nagrac-makro-w-edytorze-vim
author: Jakub Zalas
description: 
post_id: 304
created: 2009/08/01 17:41:51
created_gmt: 2009/08/01 16:41:51
comment_status: open
post_name: jak-nagrac-makro-w-edytorze-vim
status: publish
layout: post
expired: true
comments: true
tags: [vim]
---

<!--Makro to zestaw instrukcji wykonanych w jednym kroku. Podczas programowania makra pomagają nam na automatyzjację powtażalnych czynności, które stają się dzięki temu mniej nudne i podatne na błędy. Vim jako jeden z najpotężniejszych edytorów tekstu posiada tą funkcjonalność wbudowaną.-->

# Jak nagrać makro w edytorze vim?

[Makro](http://pl.wikipedia.org/wiki/Makro) to zestaw instrukcji wykonanych w jednym kroku. Podczas programowania makra pomagają nam na automatyzjację powtarzalnych czynności, które stają się dzięki temu mniej nudne i mniej podatne na błędy. [Vim](http://www.vim.org/) jako jeden z najpotężniejszych edytorów tekstu posiada tą funkcjonalność wbudowaną.  Aby nagrać makro: 

  * wchodzimy w tryb nagrywania: _qa_
  * wykonujemy zestaw instrukcji jak zwykle: _(komendy vim)_
  * zatrzymujemy proces nagrywania: _q_

## Poznanie schematu

Najpierw dobrze jest się krótko zastanowić, co powinniśmy nagrać. Załóżmy, że mamy plik z listą piosenek i artystów, który chcemy umieścić na stronie. Każdy wiersz powinien być pokazany jako osobny element listy, a tytuł piosenki musi być sformatowany kursywą. Poniżej zawartość pliku: 
    
    
    "All Along the Watchtower", Jimi Hendrix
    "Smells Like Teen Spirit", Nirvana
    "Oops!... I did it again", Britney Spears
    "A Hard Day's Night", The Beatles
    "One", Metallica
    "Lasy Pomorza", Behemoth

Aby przekonwertować pierwszą linię, używając vima, wykonalibyśmy podobną sekwencję komend: 

  * Przejdź na początek linii wciskając _^_
    
        "All Along the Watchtower", Jimi Hendrix

  * Wejdź w tryb edycji (_i_) , dodaj dwie spacje i tagi otwierające:  _<li><i>_
    
          <li><i>"All Along the Watchtower", Jimi Hendrix

  * Wyjdź z trybu edycji (_ESC_) i przesuń kursor do pierwszego przecinka: _f,_
  * Włącz tryb edycji (_i_) i dodaj tag kończący kursywę: _</i>_
    
          <li><i>"All Along the Watchtower"</i>, Jimi Hendrix

  * Wyjdź z trybu edycji (_ESC_), przeskocz na koniec linii włączając go ponownie (_A_) i dodaj tag zamykający listę _</li>_
    
          <li><i>"All Along the Watchtower"</i>, Jimi Hendrix</li>

  * Wyjdź z trybu edycji (_ESC_) i przejdź do następnej linii
Pozostałe wiersze mogą być sformatowane w identyczny sposób. Ręczne wykonanie tych samych czynności na całym pliku byłoby bardzo pracochłonne i podatne na błędy. Szczególnie, jeśli plik jest duży. Oczywistym jest, że lepiej jest pozwolić zrobić to komputerowi. 

## Rozpoczynanie nagrywania makra

Nagrywanie makra rozpoczynamy od wpisania: 
    
    
    qa

w normalnym trybie vima. '_a_' jest "pudełkiem", w którym zostanie zapisane nasze makro. Możemy wybrać jakąkolwiek literę, co daje nam możliwość zapamiętania wielu makr. 

## Nagrywanie makra

Teraz wystarczy wykonać sekwencję opisaną już wcześniej, aby przekonwertować pierwszą linię. Bardzo ważne jest, abyśmy skończyli w pozycji dogodnej do rozpoczęcia kolejnej iteracji. 

## Zapisywanie makra

Opuszczamy tryb nagrywania i zapisujemy makro wciskając: 
    
    
    q

## Uruchamianie makra

Podczas nagrywania makra sformatowaliśmy już pierwszą linię. Zakładając, że zapisaliśmy makro w rejestrze 'a', możemy przekonwertować kolejną linię wciskając: 
    
    
    @a

Nie musimy jednak wprowadzać tej sekwencji dla każdej linii. Aby sformatować pozostałe cztery wystarczy, że wpiszemy: 
    
    
    4@a

W wyniku otrzymamy: 
    
    
      <li><i>"All Along the Watchtower"</i>, Jimi Hendrix</li>
      <li><i>"Smells Like Teen Spirit"</i>, Nirvana</li>
      <li><i>"Oops!... I did it again"</i>, Britney Spears</li>
      <li><i>"A Hard Day's Night"</i>, The Beatles</li>
      <li><i>"One"</i>, Metallica</li>
      <li><i>"Lasy Pomorza"</i>, Behemoth</li>

## Podsumowanie

Głównym zadaniem programisty jest pisanie kodu. Gdy wykonujemy powtarzalne czynności ręcznie zamiast je automatyzować, wykonujemy pracę, która należy do komputera. Takie działanie czyni nas mniej czujnym i efektywnym. Poza tym, w przeciwieństwie do maszyny, popełniamy błędy. Dodanie makr do swojego zestawu umiejętności pozwoli nam zwiększyć wydajność i skupić się na właściwych zadaniach.
