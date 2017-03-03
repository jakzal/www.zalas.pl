---
title: Symfony 2 opublikowane (podczas Symfony Live 2010)
slug: symfony-2-opublikowane-podczas-symfony-live-2010
author: Jakub Zalas
description: 
post_id: 480
created: 2010/03/01 23:36:01
created_gmt: 2010/03/01 22:36:01
comment_status: open
post_name: symfony-2-opublikowane-podczas-symfony-live-2010
status: publish
layout: post
---

<!--Podczas pierwszej międzynarodowej konferencji Symfony Live, Fabien Potencier upublicznił Symfony 2. Nowoczesne podejście i sprawdzone praktyki, podpatrzone w innych pierwszoligowych projektach Open Source, tworzą wybuchową miksturę, która ma szansę zrewolucjonizować świat PHP.-->

# Symfony 2 opublikowane (podczas Symfony Live 2010)

Podczas pierwszej międzynarodowej konferencji [Symfony Live](/symfony-live-2010), Fabien Potencier upublicznił **Symfony 2**. Nowoczesne podejście i sprawdzone praktyki, podpatrzone w innych pierwszoligowych projektach Open Source, tworzą wybuchową miksturę, która ma szansę zrewolucjonizować świat PHP. Stabilna wersja planowana jest na koniec 2010 roku. Mimo to framework już wygląda imponująco. **Symfony zyskuje duże 'S'!** Oto szybki przegląd frameworka nowej generacji. 

## Zabijając magię

Wiele problemów związanych z symfony 1.x spowodowane było przez wszechobecną magię. Cóż... **w Symfony 2 magia umiera. ** Przede wszystkim będziemy zmuszeni otwarcie deklarować swoje zamiary. Framework nie będzie więcej starał się ich "zgadnąć". Powinno to zwiększyć czytelność kodu i zmniejszyć krzywą nauki. "Inteligencja" symfony 1.x sprawia, że framework staje się trudny do kontrolowania. W wielu sytuacjach nie wiedzieliśmy co i dlaczego się działo. Jawne deklarowanie swoich zamiarów zmniejszy ilość [WTFs/m](http://www.osnews.com/story/19266/WTFs_m). 

## Krzywa nauki

Symfony 1.x ma jedną z bardziej stromych krzywych nauki ze wszystkich frameworków PHP. Oferuje dużo, ale jego poznanie i uzyskanie biegłości zajmuje sporo czasu. **Podstawowe koncepcje stojące za Symfony 2 poznacie w 20 minut. **Po godzinie możecie zacząć pisać kod. Brzmi zachęcająco i zapewniam, że to prawda. Sprawdźcie sami czytając [Quick Tour](http://symfony-reloaded.org/learn). 

## Co się zmieniło?

Symfony 2 opiera się zaledwie na kilku koncepcjach. Jest niemal genialne w swojej prostocie. Osiągnięto to przez zastąpienie wielu skomplikowanych wzorców kilkoma, bardziej potężnymi. Framework jest spójny. Po poznaniu podstaw powinniście być w stanie "zgadnąć" jak działają funkcjonalności, których potrzebujecie. 

## Wstrzykiwanie Zależności (Dependency Injection Container)

Całe multum koncepcji symfony 1.x takich jak kontekst, czy konfiguracje, zostały zastąpione przez [Dependency Injection Container](http://components.symfony-project.org/dependency-injection/) (dostępny jako [Symfony Component](http://components.symfony-project.org/)). Czyni to konfigurację łatwiejszą i bardziej elastyczną. Co jest nawet ważniejsze wstrzykiwanie zależności pozwoliło uczynić **Symfony 2 lekkim frameworkiem**. 

## Paczki, tobołki, bundles (dawniej pluginy)

W 1.x pluginy wprowadzono relatywnie późno. Z założenia miały odwzorowywać strukturę aplikacji, by być rozszerzalne i reużywalne. Koncepcja słuszna, jednak architektura frameworka ją nieco ograniczyła. W Symfony 2 pluginy zyskały więcej uwagi. Zajęły tak specjalne miejsce, że zmieniono im nazwę. Pluginy od tej pory nazywamy bundles (czyli paczki, tobołki). **Właściwie, to wszystko jest bundle. **Cały kod, który będziemy pisać, czy instalować zorganizowany jest w paczki. Z uwzględnieniem frameworka. Paczki mogą być rozszeżane i nadpisywane tyle tylko ile chcemy. Daje to dużą swobodę i elastyczność (elastyczność często się pojawia, gdy mówimy o Symfony 2). 

## Warstwa prezentacji (widok)

W symfony 1.x używamy szablonów, partiali, komponentów, layoutów, slotów i komponento-slotów. Całkiem sporo koncepcji jak na prostą warstwę prezentacji. Mogą przyprawić o duży bół głowy niejednego grafika. W Symfony 2 widok składa się z szablonów i slotów (templates + slots). Oczywiście żadne funkcjonalności nie zostały zatracone. Wręcz przeciwnie. Dodano nieco elastyczności dzięki takim smaczkom jak wielopoziomowe dekorowanie szablonów. 

## Piekielna szybkość

Wszystkie nowe koncepcje stojące za **Symfony 2** czynią framework **ekstremalnie szybkim**. [Benchmark na prostej aplikacji](http://symfony-reloaded.org/fast), która wykorzystuje standardowo używane funkcjonalności frameworka udowadnia, że Symfony 2 jest: 

  * **2x** szybsze niż **Solar** 1.0.0
  * **2.5x** szybsze niż **symfony** 1.4.2
  * **3x** szybsze niż **Zend Framework** 1.10
  * **4x** szybsze niż **Lithium**
  * **6x** szybsze niż **CakePHP** 1.2.6
  * **60x** szybsze niż **Flow3**
Do tego Symfony 2 zjada **połowę mniej pamięci** niż symfony 1.x, czy Zend Framework. 

## Zawsze najlepsze

Symfony 1.x pożyczyło wiele istniejących pomysłów, czy narzędzi z innych projektów Open Source. Symfony zawsze adoptowało najlepsze, istniejące rozwiązania, mieszało je i dodawało nieco nowych. Symfony 2 wciąż podąża tą ścieżką. Dependency Injection podpatrzono w Springu (Java). Klasy loggera i cache z symfony 1.x zastąpiono klasami Zenda. Dlaczego? Bo są lepsze :) 

## Kod jest już dostępny!

Podczas konferencji pierwsza publiczna wersja kodu Symfony 2 została pchnięta do repozytorium [git na github](http://github.com/symfony/symfony)ie. Możecie go ściągać i testować. Pamiętajcie tylko, że jest to wersja aktywnie rozwijana i wiele rzeczy ulegnie zmianie. Symfony 2 nie jest gotowe na produkcyjne systemy. Specjalnie po to, aby uczyć i informować o Symfony 2, uruchomiono stronę [Symfony Reloaded](http://symfony-reloaded.org/). Na koniec zamieszczam prezentację i jej nagranie wideo z konferencji.

## Comments

**[Mr. Boo](#2996 "2010-04-02 10:35:16"):** Szkoda, że nie ma tego jeszcze. Zapowiada się bardzo ciekawe.Super było by widzieć zbudowane Magento na Symfony 2. W końcu by mniej do nauki było i łatwo było można modyfikować sklep.Liczę też, że dokumentacja będzie bardzo prosta. Bo z prezentacji nauka samego działania framerowka nie będzie problemem tylko co formularzami, mechanizmami generujące panele administracyjne itd.Ciekawi mnie czy od razu też dadzą gotowe bundle (pluginy) do obsługi logowania, rejestrowania użytkowników, mechanizmy do wysyłania emaili itd.Był bym w niebie jak bym mógł tworzyć stronę jak z klocków lego domek czy nawet zabawkę.

**[Kuba](#2997 "2010-04-03 05:25:49"):** Liczę, że core team Symfony zadba o odpowiednią dokumentację. Nigdy na nią nie narzekałem. Jeśli chodzi o bundle, to wiem, że szukuje się coś specjalnego. Jeszcze nie wiem co, ale ma to związek z zadbaniem o ich jakość.

**[darl](#3001 "2010-06-11 01:32:29"):** Wygląda całkiem smakowicie, mimo to wszystko to na razie hasła, ale wieżę w praktyce fabien i spółka nie dadzą ciała.. już nie mogę się doczekać

**[Kuba](#3003 "2010-06-12 15:00:35"):** @darl te hasla są już konwertowane na kod, którego codziennie przybywa: http://github.com/symfony/symfonyJuż za niecałe dwa tygodnie będzie można posłuchać o aktualnym stanie prac nad Symfony 2: http://www.symfony-project.org/blog/2010/05/31/the-state-of-symfony-2-online-conference

