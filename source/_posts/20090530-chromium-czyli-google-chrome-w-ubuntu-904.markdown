---
title: Chromium, czyli Google Chrome w Ubuntu 9.04
slug: chromium-czyli-google-chrome-w-ubuntu-904
author: Jakub Zalas
description: 
post_id: 208
created: 2009/05/30 09:15:54
created_gmt: 2009/05/30 08:15:54
comment_status: open
post_name: chromium-czyli-google-chrome-w-ubuntu-904
status: publish
post_type: post
---

<!--Chromium to projekt umożliwiający uruchomienie przeglądarki Google Chrome w Linuksie. W repozytoriach launchpad dostępne są źródła dla Ubuntu, dzięki czemu instalacja sprowadza się do rutynowych kroków: dodanie źródeł oprogramowania i klucza do autoryzacji, aktualizacja pakietów i zainstalowanie aplikacji.-->

# Chromium, czyli Google Chrome w Ubuntu 9.04

[Chromium](http://chromium.org/) to projekt umożliwiający uruchomienie przeglądarki Google Chrome w Linuksie. W repozytoriach [launchpad](https://launchpad.net/chromium-project) dostępne są [źródła dla Ubuntu](https://launchpad.net/~chromium-daily/+archive/ppa), dzięki czemu instalacja sprowadza się do rutynowych kroków: dodanie źródeł oprogramowania i klucza do autoryzacji, aktualizacja pakietów i zainstalowanie aplikacji. **Uwaga**: Opis instalacji w Ubuntu 9.10 (Karmic Koala) w poście "[Chromium, czyli Google Chrome w Ubuntu 9.10 (Karmic Koala)](/chromium-czyli-google-chrome-w-ubuntu-910-karmic-koala)". 

![Przeglądarka Chromium](/uploads/wp/2009/05/chromium-goyello-400x291.png)

Najpierw dodajemy źródła oprogramowania Chromium dla Ubuntu Jaunty Jackalope. 
    
    
    deb http://ppa.launchpad.net/chromium-daily/ppa/ubuntu jaunty main
    deb-src http://ppa.launchpad.net/chromium-daily/ppa/ubuntu jaunty main

Do połączenia z serwerami launchpad potrzebna jest autoryzacja kluczami, które musimy dodać przed instalacją. 
    
    
    sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0x5a9bf3bb4e5e17b5

Następnie aktualizujemy listę pakietów. 
    
    
    sudo aptitude update

Instalujemy Chromium: 
    
    
    sudo aptitude install chromium-browser

Jeśli potrzebujemy obsługi flash, najpierw upewnijmy się, że odpowiedni plugin jest zainstalowany: 
    
    
    sudo aptitude install flashplugin-nonfree

Następnie musimy go skopiować do katalogu pluginów Chromium: 
    
    
    sudo cp /usr/lib/flashplugin-installer/libflashplayer.so /usr/lib/chromium-browser/plugins/

W końcu uruchamiamy przeglądarkę z odpowiednią opcją uaktywniającą pluginy: 
    
    
    chromium-browser  --enable-plugins
