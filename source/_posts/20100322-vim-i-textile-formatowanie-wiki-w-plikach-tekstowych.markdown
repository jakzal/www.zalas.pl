---
title: Vim i Textile - formatowanie wiki w plikach tekstowych
slug: vim-i-textile-formatowanie-wiki-w-plikach-tekstowych
author: Jakub Zalas
description: 
post_id: 540
created: 2010/03/22 07:32:04
created_gmt: 2010/03/22 06:32:04
comment_status: open
post_name: vim-i-textile-formatowanie-wiki-w-plikach-tekstowych
status: publish
post_type: post
---

<!--Textile to prosty język formatowania tekstu używany na wielu forach, CMSach, czy stronach wiki (np. w Redmine). Osobiście lubię go stosować w zwykłych plikach tekstowych do robienia notatek. Plugin Textile dodaje do vima podświetlanie składni oraz możliwość podglądu i konwersji do htmla. -->

# Vim i Textile - formatowanie wiki w plikach tekstowych

[Textile](http://pl.wikipedia.org/wiki/Textile) to prosty język formatowania tekstu używany na wielu forach, CMSach, czy stronach wiki (np. w Redmine). Osobiście lubię go stosować w zwykłych plikach tekstowych do robienia notatek. [Plugin Textile](http://www.vim.org/scripts/script.php?script_id=2305) dodaje do **vim**a **podświetlanie składni** oraz możliwość **podglądu** i **konwersji do html**. ![Textile w vim](/uploads/wp//2010/03/vim-textile-400x375.png)

## Zależności

Podgląd i konwersja html wymagają języka ruby: 
    
    
    sudo aptitude install ruby libredcloth-ruby

Jeśli potrzebujecie tylko podświetlania składni, możecie pominąć instalację rubiego. 

## Plugin

Źródła pluginu jak zwykle pobieramy ze strony [Vim Scripts](http://www.vim.org/scripts/) i rozpakowujemy je do katalogu _~/.vim_. Szczegółowy opis znajdziecie na [stronie pluginu](http://www.vim.org/scripts/script.php?script_id=2305). Zwykle używam textile z plikami tekstowymi. Aby vim traktował je właściwie wystarczy dodać poniższą linijkę do pliku _~/.vim/ftdetect/txt.vim_: 
    
    
    au BufRead,BufNewFile *.txt     set filetype=textile
