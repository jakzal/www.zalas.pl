---
title: Optymalizacja FFdecsa
slug: optymalizacja-ffdecsa
author: Jakub Zalas
description: 
post_id: 19
created: 2006/12/21 16:15:34
created_gmt: 2006/12/21 15:15:34
comment_status: open
post_name: optymalizacja-ffdecsa
status: publish
post_type: post
---

<!--FFdecsa to szybka implementacja algorytmu deszyfrującego CSA dla pakietów MPEG TS. Algorytm ten jest używany w telewizji cyfrowej DVB do szyfrowania obrazu video. Korzystą z niego między innymi posiadacze kart DVB bez sprzętowego dekodera, którzy używają VDR do oglądania telewizji satelitarnej.-->

# Optymalizacja FFdecsa

FFdecsa to szybka implementacja algorytmu deszyfrującego [CSA](http://pl.wikipedia.org/wiki/Common_Scrambling_Algorithm) dla pakietów [MPEG TS](http://en.wikipedia.org/wiki/Transport_stream). Algorytm ten jest używany w telewizji cyfrowej [DVB](http://pl.wikipedia.org/wiki/DVB) do szyfrowania obrazu video. Korzystą z niego między innymi posiadacze kart [DVB](http://pl.wikipedia.org/wiki/DVB) bez sprzętowego dekodera, którzy używają [VDR](http://www.cadsoft.de/vdr/) do oglądania telewizji satelitarnej. Jak podaje autor, jego implementacja jest ponad 800% szybsza niż najszybsza, którą znalazł. Wyjaśnia to nazwę programu, której skrót jest rowinięty w jednym z pytań w FAQ (dołączonym do źródeł). Dzięki takiemu wzrostowi wydajności zyskujemy między innymi następujące właściwości: 

  * deszyfracja strumienia 8Mb/s zabiera 5% czasu procesora zamiast 40%,
  * deszyfracja całego transpondera (z wszystkimi kanałami lub z dużym strumieniem HDTV) niosącego 38Mb/s zabiera 23% czasu procesora zamiast 190% (>100%, nie do odszyfrowania w czasie rzeczywistym),
  * bardzo wolny procesor może odkodować jeden kanał bez problemów.
Autor zadbał o dobrą dokumentację swojego programu. Warto przeczytać dołączony do źródeł plik README oraz dokumnety w katalogu docs. Dostarczą nam one odpowiedzi na większość nasuwających się pytań ;) Istnieją dwa sposoby optymalizacji FFdecsa. Przed kompilacją możemy wyedytować plik Makefile, aby dostosować flagi kompilatora. Podstawa to zmiana architektury procesora (-march). Drugą opcją jest zmiana strategii grupowania bitowego. Ma to ogromny wpływ na wydajność algorytmu, a nie jest trudne do wykonania. Wystarczy w pliku FFdecsa.c zmienić definicję PARALLEL_MODE. Dostępne wartości, z których możemy wybierać zdefiniowane są w tym samym pliku nieco wyżej. Aby uzyskać najlepszą wydajność (oraz z ciekawości) skompilowałem FFdecsa dla każdego dostępnego wariantu PARALLEL_MODE. Po kompilacji można wywołać program FFdecsa_test, który przetestuje poprawność dekrypcji i oszacuje jej prędkość. Dla uzyskania lepszych rezultatów dobrze jest przeprowadzić testy na bezczynnej maszynie i podwyższyć priorytet zadania przy pomocy polecenia nice (alternatywnie można wywołać 'make test'): 
    
    
    nice -n -19 ./FFdecsa_test

Dla procesora AMD Athlon XP 2000+ (1,67MHz) uzyskałem poniższe wyniki. 

PARALLEL_32_4CHAR
6.79 Mbit/s
4615.33 pkts/s

PARALLEL_32_4CHARA
6.19 Mbit/s
4211.85 pkts/s

PARALLEL_32_INT
103.35 Mbit/s
70216.50 pkts/s

PARALLEL_64_8CHAR
7.95 Mbit/s
5407.34 pkts/s

PARALLEL_64_8CHARA
7.74 Mbit/s
5258.37 pkts/s

PARALLEL_64_2INT
36.58 Mbit/s
24850.89 pkts/s

PARALLEL_64_LONG
85.68 Mbit/s
58208.91 pkts/s

PARALLEL_64_MMX
132.96 Mbit/s
90326.34 pkts/s

PARALLEL_128_16CHAR
10.37 Mbit/s
7050.85 pkts/s

PARALLEL_128_16CHARA
4.54 Mbit/s
3085.76 pkts/s

PARALLEL_128_4INT
63.87 Mbit/s
43391.91 pkts/s

PARALLEL_128_2LONG
30.87 Mbit/s
20975.88 pkts/s

PARALLEL_128_2MMX
14.53 Mbit/s
9874.25 pkts/s

PARALLEL_128_SSE
Naruszenie ochrony pamięci
Najlepszym wyborem (podobnie jak u autora) jest tryb PARALLEL_64_MMX. Prawdopodobnie będzie tak w przypadku większości procesorów. Tryb PARALLEL_32_INT nie okazał się wiele gorszym, a skoro jest bardziej przenośnym, często może być lepszym wyborem (dlatego jest wartością domyślną). PARALLEL_128_SSE spowodował naruszenie ochrony pamięci i w sumie nie bardzo wiem dlaczego (bug gcc? specyfika instrukcji sse w athlonie?). Polecam przeprowadzenie testów u siebie choćby dla kilku wyróżniających się trybów :D

## Comments

**[Misiolap](#2 "2007-01-05 15:19:16"):** W starszych wersjach ffdcsa, które nie by ły dołączone do vdr-sc PARALLEL_128_SSE nie powoduje segfaulta.

**[Jakub Zalas](#3 "2007-01-05 18:03:22"):** Masz dostęp do starszej wersji? FFdecsa 1.0.0 jest już dostępna od bardzo dawna i trudno znaleźć poprzednią.

**[Misiolap](#4 "2007-01-06 01:08:20"):** W tej wersji SSE działa u mnie prawidłowo: http://vdr.bluox.org/download/vdr-sc/archives/FFdecsa-1.0.0.tar.bz2 W tej z paczki vdr-sc zrzuca segfault.

**[Michał Górny](#14 "2007-04-07 10:28:54"):** Uch, ja nawet SSE nie próbowałem, ze względu na kompatybilność z drugą maszyną (tam czystej krwi Athlon). Widzę, że wiele nie straciłem ( ;.

**[Jakub Zalas](#15 "2007-04-08 10:26:01"):** Mój Athlon obsługuje sse ;)

