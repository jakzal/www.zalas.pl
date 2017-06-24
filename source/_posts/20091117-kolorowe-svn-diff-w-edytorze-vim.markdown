---
title: Kolorowe svn diff w edytorze vim
slug: kolorowe-svn-diff-w-edytorze-vim
author: Jakub Zalas
description: 
post_id: 412
created: 2009/11/17 16:28:33
created_gmt: 2009/11/17 15:28:33
comment_status: open
post_name: kolorowe-svn-diff-w-edytorze-vim
status: publish
layout: post
expired: true
comments: true
tags: [vim]
---

Jakiś czas temu tłumaczyłem [jak pokolorować wynik svn diff](/kolorowanie-wyniku-svn-diff). Możemy uzyskać podobny rezultat przy pomocy **vim**a. Druga metoda okazuje się wygodniejsza, gdy mamy do zatwierdzenia dużą ilość kodu. ![Wynik svn diff w edytorze vim](/uploads/wp//2009/11/vim-diff-400x168.png) Wszystko co musimy zrobić to przekierować wynik _svn diff_ na wejście _view_:
    
    
    svn diff lib/zWebBrowser.class.php | view -

_view_ otworzy sesję vim w trybie tylko do odczytku. Dzięki temu edytor nie zapyta nas przy wyjściu, czy zapisać plik. Jeśli spodziewamy się często używać tej techniki, dobrze jest opakować polecenie w funkcję bash. Poniższy kod możemy wkleić do pliku _~/.bashrc._
    
    
    svndiff()
    {
      svn diff "${@}" | view -
    }

Uczyni to naszą komendę nieco krótszą: 
    
    
    svndiff lib/zWebBrowser.class.php
