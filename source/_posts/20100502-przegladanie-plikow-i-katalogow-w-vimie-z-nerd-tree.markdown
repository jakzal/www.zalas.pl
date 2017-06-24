---
title: Przeglądanie plików i katalogów w vimie z NERD tree
slug: przegladanie-plikow-i-katalogow-w-vimie-z-nerd-tree
author: Jakub Zalas
description: 
post_id: 579
created: 2010/05/02 05:33:36
created_gmt: 2010/05/02 04:33:36
comment_status: open
post_name: przegladanie-plikow-i-katalogow-w-vimie-z-nerd-tree
status: publish
layout: post
expired: true
comments: true
tags: [vim]
---

<!--Przeglądanie, otwieranie, zmiana nazwy, czy przenoszenie plików i katalogów to czynności wykonywane podczas codziennego pisania kodu. W popularnych IDE odbywa się to zwykle przy pomocy eksploratora plików. W vimie lubię używać do tego celu pluginu NERD tree.-->

# Przeglądanie plików i katalogów w vimie z NERD tree

Przeglądanie, otwieranie, zmiana nazwy, czy przenoszenie plików i katalogów to czynności wykonywane podczas codziennego pisania kodu. W popularnych IDE odbywa się to zwykle przy pomocy eksploratora plików. W vimie lubię używać do tego celu [pluginu NERD tree](http://www.vim.org/scripts/script.php?script_id=1658). 

![NERD tree - plugin vim](/uploads/wp//2010/05/nerdtree-400x275.png)

## Możliwości NERD Tree

**NERD tree** pozwala: 

  * **Nawigować** i **skakać** po drzewie katalogów
  * **Otwierać** pliki w aktualnym oknie, zakładkach i podzielonym widoku (horyzontalnie i wertykalnie)
  * **Zmienić** aktualny katalog roboczy
  * **Tworzyć,** **przenosić**, **kopiować** i **uswać** pliki i katalogi
  * **Filtrować **widoczne pliki i katalogi
  * **Tworzyć zakładki**

## Instalacja

Pobieramy źródła [ze strony pluginu](http://www.vim.org/scripts/script.php?script_id=1658) i rozpakowujemy je do katalogu _~/.vim_. Najwygodniej jest utworzyć sobie skrót uruchamiający **NERD tree**. Ja używam _ctrl+n_ i w tym celu dodałem poniższą linijkę do swojego pliku _~/.vimrc_: 
    
    
    nmap <silent> <c-n> :NERDTreeToggle<CR>

## Jak korzystać z NERD tree?

Uruchamiamy vima i wpsiujemy _:NERDTreeToggle_ lub _ctrl+n_. Druga wersja zadziała tylko, jeśli utworzyliśmy skrót. W tej chwili powinniśmy zobaczyć strukturę katalogów. Sugeruję zacząć od przeczytania pomocy i poznania podstawowych funkcji pluginu. Pomoc dostępna jest pod klawiszem _?_ (działa, gdy kursor jest w obrębie okna pluginu).
