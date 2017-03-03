---
title: Cachowanie stron internetowych za pomocą skryptu bash i pliku .htaccess
slug: cachowanie-stron-internetowych-za-pomoca-skryptu-bash-i-pliku-htaccess
author: Jakub Zalas
description: 
post_id: 281
created: 2009/07/04 08:43:25
created_gmt: 2009/07/04 07:43:25
comment_status: open
post_name: cachowanie-stron-internetowych-za-pomoca-skryptu-bash-i-pliku-htaccess
status: publish
layout: post
---

<!--Powierzono mi ostatnio zadanie uczynienia kompletnie niewydajnej strony www na tyle wydajną, aby dać zespołowi czas  na jej naprawienie. Nie znałem kodu i technologii wspomnianej aplikacji, nie miałem też wystarczającej ilości czasu na jej poznanie.-->

# Cachowanie stron internetowych za pomocą skryptu bash i pliku .htaccess

Powierzono mi ostatnio zadanie uczynienia kompletnie niewydajnej strony www na tyle wydajną, aby dać zespołowi czas  na jej naprawienie. Nie znałem kodu i technologii wspomnianej aplikacji, nie miałem też wystarczającej ilości czasu na jej poznanie. Głównym skutkiem działania aplikacji było wysokie obciążenie serwera przy stosunkowo niskiej ilości użytkowników. Jedną z przyczyn tego stanu była duża ilość dodatkowych żądań wykonywanych przez już załadowaną stronę. Każde jej wyświetlenie skutkowało kolejnymi połączeniami do serwera w celu pobrania kilku plików XML. Generowanie tych plików było kosztowne, a nie zmieniały się one zbyt często. Stanowiły idealny materiał do umieszczenia w cache'u. Moje rozwiązanie miało być napisane natychmiast i działać tylko tymczasowo. Szybko stworzyłem prosty skrypt w bashu, który sprostał zadaniu wyśmienicie. Skrypt analizuje logi apache i wyszukuje adresy URL, które powinny być cachowane. Znalezione podstrony zapisywane są na dysku. Oto cały skrypt: 
    
    
    #!/bin/bash
    
    # CONFIG
    base_path="/var/www/heavyloadedapp.com/web"
    xml_path="/var/www/heavyloadedapp.com/web/cache-xml"
    url="http://heavyloadedapp.com"
    paths=$(cat /var/log/httpd/heavyloadedapp.com.log | grep XML | less | awk '{print $7}' | sort | uniq)
    user="apache"
    rights="755"
    # CONFIG END
    
    if [ ! -d $xml_path ]; then
      mkdir $xml_path
    fi
    
    cd $xml_path
    
    for path in $paths; do
      rel_path=$(echo $path | sed -e 's/^\///' | sed -e 's/^\(.*\)?\(.*\)$/\1/')
      if [ ! -f $rel_path ]; then
        if [ $(echo "$rel_path" | grep -E '\/') ]; then
          dir=$(echo $rel_path | sed -e 's/\(.*\)\/.*/\1/')
          mkdir -p $dir
        fi
        /usr/bin/wget -U "CacheBrowser" -nv $url/$rel_path -O $rel_path
      fi
    done
    
    chown -R $user $xml_path
    chmod -R $rights $xml_path
    
    cd -

Na początku znajdują się opcje konfiguracyjne. Należy podać ścieżkę do miejsca instalacji aplikacji, katalogu z cachem i bazowego adresu URL. Zmienna _$paths_ trzyma listę adresów znalezionych w pliku logów apache. Użyłem polecenia grep, aby wyszukać adresy zawierające słowo 'XML', następnie je posortowałem i zadbałem, aby każdy wystąpił tylko raz. Ten fragment musi być dostosowany do problemu, który chcemy rozwiązać. Grep powinien wyłowić tylko kandydatów do cachowania. W pętli głównej skryptu sprawdzam znalezione adresy i jeśli nie są jeszcze zapisane na dysku, używam wget do ich pobrania. Nowe dokumenty zapisywane są w katalogu cache-xml.  Przy kolejnych żądaniach pobierane są prosto stamtąd, za co odpowiadają poniższe regułki umieszczone w pliku .htaccess: 
    
    
    RewriteEngine On
    RewriteBase /
    
    ### XML Caching ###
    RewriteCond %{REQUEST_URI} ^(.*XML.*)$
    RewriteCond %{REQUEST_URI} !^.*cache-xml(.*)$
    RewriteCond %{DOCUMENT_ROOT}/cache-xml%1 -f
    RewriteCond %{HTTP_USER_AGENT} !CacheBrowser
    RewriteRule .* cache-xml%1 [L]
    ### XML Caching END ###

W skrypcie zmieniłem identyfikację klienta (User Agent) na _CacheBrowser_. Dzięki temu w regułkach .htaccess mogę rozpoznać żądania wykonane przez skrypt i potraktować je w odrębny sposów. To wszystko. Podczas pierwszych odwiedzin danego adresu jest on logowany przez apache.  Uruchamiany raz na jakiś czas w cronie skrypt zapisuje nowe strony na dysku. Przy następnym wywołaniu takiego adresu aplikacja nie jest nawet uruchamiana. **Nic nie jest szybsze od plików statycznych.**

## Gdzie tkwi haczyk?

Rozwiązanie jest proste i działa świetnie, ale ma kilka minusów. Przede wszystkim pliki nie są odświeżane. Raz zapisany w cache'u plik nigdy się nie przedawnia. Odświeżanie może być zrobione na dwa sposoby. Możemy czyścić cache automatycznie (raz na jakiś czas) lub czyścić go z poziomu aplikacji (na żądanie lub przy zmianie danych). Pierwsze rozwiązanie sprowadza się do dodania odpowiedniego skryptu cyklicznie wywoływanego za pomocą crona. Jednak użytkownicy z reguły oczekują, że zmiany będą widoczne zaraz po ich wprowadzeniu. Niestety drugie wyjście ściśle zależy od używanej technologii. Inny problem ujawnia się przy stronach wymagających autoryzacji. Po prostu nie możemy ich cachować w ten sposób. Linkijka skryptu, który wyszukuje adresy do cachowania powinna być zmodyfikowana w taki sposób, aby odrzucała adresy wymagające zalogowanego użytkownika. 

## Wnioski

Zbyt często programiści zapominają o cachowaniu danych, które nie zmieniają się zbyt często lub są kosztowne do wygenerowania. Poza tym dobrą praktyką jest ograniczenie żądań potrzebnych do wyświetlenia jednej strony www. Szczególnie tyczy się to wysoce obciążonych serwisów. Mam nadzieję, że pokazałem iż za wydajnym cachowaniem nie musi stać skomplikowane rozwiązanie.  Z drugiej strony optymalizacja dynamicznych stron nastręcza pewnych problemów i wymaga szczególnego traktowania. Dobranie odpowiednich narzędzi do rozwiązania danego problemu jest bardzo ważne. Wspomniany serwis niestety nie był napisany w technologii umożliwiającej szybką implementację cachowania.

## Comments

**[Jurek](#2975 "2009-07-15 07:28:13"):** Fajne :) A jak człowiek pomyśli o memcached, opcode cacherach, klastrach i innych "dziwach" przyspieszających strone - GENIALNE :)

**[BrakU](#3056 "2011-07-14 05:42:27"):** Cache można by czyścić przy wyskakującym komunikacie na żądanie lub przy zmianie danych z poziomu przeglądarki lub aplikacji. Tylko kod musiałby uwzględniać opcje dla wielu przeglądarek, technologii.

