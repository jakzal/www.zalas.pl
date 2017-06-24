---
title: Kolorowanie wyniku svn diff
slug: kolorowanie-wyniku-svn-diff
author: Jakub Zalas
description: 
post_id: 257
created: 2009/06/17 05:10:38
created_gmt: 2009/06/17 04:10:38
comment_status: open
post_name: kolorowanie-wyniku-svn-diff
status: publish
layout: post
expired: true
comments: true
tags: [bash]
---

Polecenie _svn diff_ umożliwia obejrzenie zmian pomiędzy dwoma wersjami plików z repozytorium svn. Jego wyjście nie zawsze jest czytelne. Na początku zmienionych linii umieszczane są tylko  '+' (jeśli linia została dodana) lub '-' (jeśli została usunięta).

![svn diff in black and white](/uploads/wp//2009/06/svn-diff-before-399x183.png)

Możemy nieco ułatwić sobie pracę przez instalację [colordiff](http://colordiff.sourceforge.net/). Program opakowuje polecenie _diff_ i zwraca taki sam rezultat, jednak pokolorowany. 

![svn diff in colors](/uploads/wp//2009/06/svn-diff-after-400x183.png)

W ubuntu colordiff instalujemy prostym poleceniem: 
    
    
    sudo aptitude install colordiff

Wynik komend _diff_, _svn diff_ i innych im podobnym można teraz przekierować potokiem do _colordiff_, aby uzyskać kolorowe wyjście__: 
    
    
    svn diff plugins/zMobyPicturePlugin/lib/zMobyPictureClient.class.php | colordiff

Dla używających powłoki bash polecam zadeklarowanie w pliku _~/.bashrc_ prostej funkcji: 
    
    
    svndiff()
    {
      svn diff "${@}" | colordiff
    }

Dzięki temu po ponownym zalogowaniu możemy nieco skrócić wywołanie polecenia: 
    
    
    svndiff plugins/zMobyPicturePlugin/lib/zMobyPictureClient.class.php

**Notatka**: Podobny rezultat możemy uzyskać za pomocą edytora vim. Przeczytaj "[Kolorowe svn diff w edytorze vim](/kolorowe-svn-diff-w-edytorze-vim)", aby dowiedzieć się więcej na ten temat.
