---
title: Instalacja sasc-ng w Ubuntu 10.10
slug: instalacja-sasc-ng-ubuntu-1010
author: Jakub Zalas
description: 
post_id: 685
created: 2010/11/16 20:48:40
created_gmt: 2010/11/16 19:48:40
comment_status: open
post_name: instalacja-sasc-ng-ubuntu-1010
status: publish
layout: post
expired: true
comments: true
tags: [ubuntu,sasc-ng]
---

<!--Jak już kiedyś pisałem, sasc-ng pozwala na oglądanie kodowanych kanałów w dowolnej aplikacji obsługującej standard dvb. Sama aplikacja nie musi "wiedzieć", że kanał jest kodowany. Moduł jądra kompilowany z sasc-ng tworzy dodatkowe urządzenie, na którym dostępny jest odkodowany sygnał. Jedyne do czego musimy zmusić aplikację DVB, to wskazać właściwe urządzenie.

Sasc-ng nie jest dostępny w oficjalnych repozytoriach Ubuntu, dlatego trzeba go skompilować.-->

# Instalacja sasc-ng w Ubuntu 10.10

![Matrix](/uploads/wp//2010/11/matrix.png) Źródło zdjęcia: http://picasaweb.google.com/lh/photo/JMArfIS7cNM4bAtfH4_blQ Jak [już kiedyś pisałem](/kodowane-kanaly-telewizji-satelitarnej-w-dowolnej-aplikacji-dvb), sasc-ng pozwala na oglądanie kodowanych kanałów w dowolnej aplikacji obsługującej standard dvb. Sama aplikacja nie musi "wiedzieć", że kanał jest kodowany. Moduł jądra kompilowany z sasc-ng tworzy dodatkowe urządzenie, na którym dostępny jest odkodowany sygnał. Jedyne do czego musimy zmusić aplikację DVB, to wskazać właściwe urządzenie. Sasc-ng nie jest dostępny w oficjalnych repozytoriach Ubuntu, dlatego trzeba go skompilować. 

## Instalacja zależności

Zaczynamy od instalacji nagłówków jądra i kilku innych pakietów potrzebnych do kompilacji: 
    
    
    sudo apt-get install linux-headers-`uname -r` build-essential mercurial libssl-dev gettext

## Pobranie źródeł

Źródła sasc-ng pobieramy wprost z repozytorium dewelopera: 
    
    
    mkdir -p ~/Apps/src
    cd ~/Apps/src
    hg clone http://85.17.209.13:6100/sc

## Nałożenie łatki usuwającej sprawdzanie uprawnień

Niestety sasc-ng odmawiał działania z moją kartą Cyfry+. Okazało się, że maska uprawnień PBM obliczana jest nieprawidłowo. Okazało się też, że jej obliczanie wydaje się być niepotrzebne (wielkie dzięki dla Wojtka za zauważenie tego!). [Łatka](https://gist.github.com/675636) sprawia, że metoda sprawdzająca uprawnienia zawsze zwróci _true_. 
    
    
    cd ~/Apps/src/
    wget https://gist.github.com/raw/675636/185dd32935ce1e5e8b7a876d82859bf80d0cc71e/sc-seca.c.patch
    cd ~/Apps/src/sc
    patch -p1 < ../sc-seca.c.patch

## Kompilacja

Wreszcie czas na kompilację programu i modułu jądra: 
    
    
    cd ~/Apps/src/sc/contrib/sasc-ng/
    chmod +x configure
    chmod +x dvbloopback/module/config_dvb.pl
    ./configure
    make
    make module

## Instalacja

Kopiujemy moduł, binarkę i kilka bibliotek w ogólnie dostępne miejsca: 
    
    
    cd ~/Apps/src/sc/contrib/sasc-ng/
    sudo rm /lib/modules/`uname -r`/misc/dvbloopback.ko
    sudo cp sasc-ng /usr/bin
    sudo cp sc/PLUGINS/lib/* /usr/lib/
    sudo mkdir /lib/modules/`uname -r`/misc
    sudo /usr/bin/install dvbloopback.ko /lib/modules/`uname -r`/misc/
    sudo depmod

## Konfiguracja

Tworzymy katalog na konfigurację: 
    
    
    sudo mkdir /etc/sc_files

Przykładowe pliki konfiguracyjne znajdziemy w katalogu _examples_ źródeł sc (ściągnęliśmy je do _~/Apps/src/sc_). Kartę Cyfry wpinam do programatora Phoenix, którego mam podłączonego do portu COM. Aby sasc-ng 'zobaczył' kartę, tworzymy wpis w _/etc/sc_files/cardslot.conf_: 
    
    
    sudo su -c "echo 'serial:/dev/ttyS0:0:0' > /etc/sc_files/cardslot.conf"

## Uruchomienie

Przed pierwszym uruchomieniem musimy załadować moduł jądra: 
    
    
    sudo modprobe dvbloopback

Teraz możemy już uruchomić sasc-ng: 
    
    
    sasc-ng -j 0:1 --cam-budget --cam-dir /etc/sc_files

Jak zwykle wszystkie dostępne opcje dostępne są po wywołaniu _sasc-ng -h_. 

## Testowanie z mplayerem

Powinniśmy już być w stanie zobaczyć obraz kodowanych kanałów w aplikacjach typu mplayer, czy xine. Pokażę to na podstawie mplayera. Jeśli nie posiadamy listy kanałów, tworzymy ją szybko: 
    
    
    echo 'PLANETE(CYFRA +):10719:v:0:27500:165:100:4406' > ~/.mplayer/channels.conf

Uruchamiamy mplayer używając protokołu _dvb://_. Ważne jest, żeby pamiętać o wskazaniu odpowiedniego urządzenia DVB (w tym przypadku '2'): 
    
    
    mplayer dvb://2@

## Testowanie z VDR

VDR sam rozponaje, czy program jest kodowany. Jeśli nie mamy softcama w VDR, to VDR uzna, że nie może pokazać obrazu. Musimy go nieco "ogłupić". Po pierwsze wszystkie kanały muszą być oznaczone jako niekodowane. Zamiast: 
    
    
    PLANETE;CYFRA +:10719:VC56M2O0S0:S13.0E:27500:165=2:100=pol@4:0:**100**:4406:318:11000:0

Powinniśmy mieć: 
    
    
    PLANETE;CYFRA +:10719:VC56M2O0S0:S13.0E:27500:165=2:100=pol@4:0:**0**:4406:318:11000:0

'0' oznacza program [FTA](http://pl.wikipedia.org/wiki/FTA). Poza tym musimy sprawić, aby VDR nie nadpisał nam naszych zmian. W tym celu w pliku _/etc/vdr/setup.conf_ zmieniamy wartość opcji _UpdateChannels_ na _0_: 
    
    
    UpdateChannels = 0

Pozostało jeszcze kazać VDR korzystać z drugiego urządzenia DVB, na którym dostępny jest odkodowany sygnał. Do zmiennej OPTIONS w pliku _/etc/default/vdr_ dodajemy opcję _-D_: 
    
    
    OPTIONS="-w 60 -D 1"

**Uwaga**: VDR numeruje urządzenia od zera. Dlatego wskazujemy urządzenie numer jeden. Zakładając, że mamy już uruchomiony sasc-ng, startujemy VDR: 
    
    
    sudo service vdr start

i cieszymy się odkodowanym obrazem TV. **Wskazówka**: Sprawienie, żeby wszystkie kanały były widziane jako FTA może być pracochłonne. Poniższym skryptem robimy to automatycznie dla całej listy: 
    
    
    sed -i -e 's/:\([^:]\+\)\(:\([^:]\+\):\([^:]\+\):\([^:]\+\):\([^:]\+\)\)$/:0\2/' channels.conf

## Skrypt startowy

VDR jest domyślnie uruchamiany podczas startu systemu. Do pełni szczęścia chcielibyśmy, aby sasc-ng uruchamiany był przed VDR. Napisałem w tym celu skrypt init.d dla Ubuntu: 
    
    
    #! /bin/sh
    
    ### BEGIN INIT INFO
    # Provides:          sasc-ng
    # Required-Start:    $local_fs $remote_fs $network $syslog
    # Required-Stop:     $local_fs $remote_fs $network $syslog
    # X-Start-Before:    $vdr
    # Default-Start:     2 3 4 5
    # Default-Stop:      0 1 6
    # Short-Description: starts sasc-ng
    # Description:       starts sasc-ng
    ### END INIT INFO
    
    PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
    NAME=sasc-ng
    DESC=sasc-ng
    
    test -x $DAEMON || exit 0
    
    PIDFILE="/var/run/$NAME.pid"
    SASC_NG="/usr/bin/sasc-ng"
    OPTIONS="-j 0:1 --cam-budget"
    CAM_DIR="./sc_files"
    
    # Include sasc-ng defaults if available
    if [ -f /etc/default/sasc-ng ] ; then
    	. /etc/default/sasc-ng
    fi
    
    SASC_NG_ARGUMENTS="$OPTIONS --cam-dir $CAM_DIR -P $PIDFILE -D"
    
    set -e
    
    . /lib/lsb/init-functions
    
    case "$1" in
      start)
    	echo "Loading dvbloopback module"
    	modprobe dvbloopback
    
    	echo -n "Starting $DESC: "
    	start-stop-daemon --start --quiet --pidfile $PIDFILE --exec "$SASC_NG" -- $SASC_NG_ARGUMENTS || true
    	echo "$NAME."
    	;;
      stop)
    	echo -n "Stopping $DESC: "
    	start-stop-daemon --stop --quiet --pidfile $PIDFILE --exec "$SASC_NG" || true
    	echo "$NAME."
    
    	sleep 1
    	echo "Unloading dvbloopback module"
    	rmmod dvbloopback
    	;;
      restart)
    	echo -n "Restarting $DESC: "
    	start-stop-daemon --stop --quiet --pidfile $PIDFILE --exec "$SASC_NG" || true
    	sleep 1
    	start-stop-daemon --start --quiet --pidfile $PIDFILE --exec "$SASC_NG" -- $SASC_NG_ARGUMENTS || true
    	echo "$NAME."
    	;;
      status)
    	status_of_proc -p $PIDFILE "$SASC_NG" sasc-ng && exit 0 || exit $?
    	;;
      *)
    	echo "Usage: $NAME {start|stop|restart|status}" >&2
    	exit 1
    	;;
    esac
    
    exit 0

Skrypt kopiujemy do /etc/init.d/sasc-ng i nadajemy mu prawa do wykonywania (_chmod +x /etc/init.d/sasc-ng_). Konfigurację przeprowadzamy w _/etc/default/sasc-ng_: 
    
    
    OPTIONS="-j 0:1 --cam-budget"
    CAM_DIR="/etc/sc_files"

Teraz sasc-ng uruchamiamy i zatrzymujemy jak każdą usługę Ubuntu: 
    
    
    sudo service sasc-ng start

Aby program uruchamiany był ze startem Ubuntu wykonujemy: 
    
    
    sudo update-rc.d sasc-ng defaults

## Uwagi

Mam nadzieję, że opis jest wystarczająco przejrzysty. Czekam na ewentualne sugestie, czy też inne komentarze ;)

## Comments

**[Mick](#3010 "2010-12-13 12:31:40"):** To rzeczywiście działa ? Na jakiej DVB testowałeś ? Pozdrawiam

**[Kuba](#3011 "2010-12-17 00:29:32"):** @Mick Cały czas korzystam z tego zestawu. Mam kartę SkyStar (już dość wysłużoną).

**[Marcin](#3019 "2011-02-11 13:10:44"):** Świetny poradnik :)Mam problem przy "sudo modprobe dvbloopback" wywala miFATAL: Error inserting dvbloopback (/lib/modules/2.6.32-28-server/misc/dvbloopback.ko): Unknown symbol in module, or unknown parameter (see dmesg)dmesqFeb 11 22:07:30 box kernel: [ 3469.124069] dvbloopback: disagrees about version of symbol dvb_register_adapterFeb 11 22:07:30 box kernel: [ 3469.124079] dvbloopback: Unknown symbol dvb_register_adapterFeb 11 22:07:30 box kernel: [ 3469.124622] dvbloopback: disagrees about version of symbol dvb_unregister_deviceFeb 11 22:07:30 box kernel: [ 3469.124627] dvbloopback: Unknown symbol dvb_unregister_deviceFeb 11 22:07:30 box kernel: [ 3469.125911] dvbloopback: disagrees about version of symbol dvb_register_deviceFeb 11 22:07:30 box kernel: [ 3469.125916] dvbloopback: Unknown symbol dvb_register_deviceFeb 11 22:07:30 box kernel: [ 3469.126130] dvbloopback: disagrees about version of symbol dvb_unregister_adapterFeb 11 22:07:30 box kernel: [ 3469.126135] dvbloopback: Unknown symbol dvb_unregister_adapterMój systemUbuntu Server 10.04 LTS2.6.32-28-serverKarta SkyStar HD2 (stery s2-liplianin-dkms)Czy szanowny autor może poratować ?

**[Kuba](#3020 "2011-02-13 07:09:57"):** @Marcin Wygląda, że problem leży po stronie sterowników do Twojej karty. Nie wiem o na to poradzić, oprócz google'a. Sporo ludzi miało podobny problem.

**[Marcin](#3023 "2011-02-14 01:16:39"):** Dzięki za odpowiedz, będę walczyć dalej :)Tak na marginesie, jak nazywa się ten dodatek captcha z obrazkami ?

**[Kuba](#3024 "2011-02-14 04:43:24"):** YELLOcaptcha: http://captcha.goyello.com/

**[Marcin](#3027 "2011-02-16 02:36:35"):** To znowu ja :) Zostawię dla potomnych :) SASC-NG kompiluje się tylko z jajem do wersji 2.6.33, jest możliwość kompilacji w wyższej wersji jaja, ale trzeba podmieniać nagłówki itp. przy ./configure trzeba wskazać sterowniki do karty DVB np. ./configure --dvb-dir=/usr/src/s2-liplianin Pozdrawiam

**[kamiKAC](#3037 "2011-03-22 04:19:44"):** W jakiej wersji gcc i g++ oraz na jakim procku kompiluje wam się vdr-sasc-ng? Ja miałem wcześniej P4 i ładnie się kompilowało i działało. Zmieniłem procka na Athlona XP i przy kompilacji mam warningi. Po załadowaniu modułu dvbloopback nie mam błędów w dmesg, jednak po włączeniu kodowanego programu sasc-ng zawiesza się i obciąża bardzo mocno procka. Pomaga tylko ubicie sasc-ng.Ma ktoś jakieś pomysły?

**[Kuba](#3038 "2011-03-25 16:34:47"):** @kamiKAC: ja też mam Athlona XP. Nie mogę teraz sprawdzić wersji gcc i g++, ale są to domyślnie dostępne w Ubuntu 10.10.

**[pio](#3043 "2011-05-04 16:37:24"):** Hi,Mi tak po prostu nie działa, niby wszystko poszło gładko, tyle że nic nie widać żadnego obrazu nie ma, sasc-ng sypie czymś takim, chyba to samo jak testowo wyjęłem karte, poradzisz coś?May 5 01:26:17.191 CAM(core.ecm): 0.1: descriptor 18 13 e9 cf 02 00 68May 5 01:26:17.191 CAM(core.ecm): 0.1: found 1813(0000) (Nagra2) id 0000 with ecm 9cf/80 (dup) (already present)May 5 01:26:17.199 CAM(core.ecm): 0.1: try system Seca (0100) id 0068 with ecm 9cf (pri=-10)May 5 01:26:17.199 CAM(core.ecm): 0.1: stopping message log until valid key is foundMay 5 01:27:13.792 CAM(core.auStats): EMM packet load average (1/4/10min) 239 59 23 pks/sMay 5 01:28:13.843 CAM(core.auStats): EMM packet load average (1/4/10min) 231 117 47 pks/sMay 5 01:29:13.892 CAM(core.auStats): EMM packet load average (1/4/10min) 237 148 59 pks/sMay 5 01:30:13.902 CAM(core.auStats): EMM packet load average (1/4/10min) 227 205 82 pks/sMay 5 01:31:13.913 CAM(core.auStats): EMM packet load average (1/4/10min) 219 230 104 pks/sMay 5 01:32:13.915 CAM(core.auStats): EMM packet load average (1/4/10min) 214 224 125 pks/sMay 5 01:33:13.964 CAM(core.auStats): EMM packet load average (1/4/10min) 169 207 142 pks/s

**[Kuba](#3044 "2011-05-05 09:20:03"):** @pio: Łatkę nałożyłeś? Jeśli tak, to wielę nie pomogę. Jeśli nie, nałóż :)

**[pio](#3045 "2011-05-05 22:16:31"):** Tak, nałożyłem.

**[Komuch](#3064 "2011-08-10 06:47:44"):** Niestety nie kompiluje się, próbowałem w wersjach 10.04LTS, 10.10, 11.04. Za każdym razem to:g++ -Wall -D__user= -g -o objs/sasccam.o -c -DRELEASE_VERSION=\"0.0.2\" -D__KERNEL_STRICT_NAMES -Isc/PLUGINS/src/sc-src -I./sc/include -Idvbloopback/module -I/lib/modules/2.6.32-22-generic/build/include sc/sasccam.cppsc/sasccam.cpp: In constructor ‘sascCam::sascCam(int)’:sc/sasccam.cpp:64: error: ‘class cSascDvbDevice’ has no member named ‘Cam’sc/sasccam.cpp: In member function ‘void sascCam::AddPrg(int, int*, const unsigned char*, int)’:sc/sasccam.cpp:80: error: invalid use of incomplete type ‘struct cPrg’sc/PLUGINS/src/sc-src/cam.h:41: error: forward declaration of ‘struct cPrg’sc/sasccam.cpp:81: error: invalid use of incomplete type ‘struct cPrg’sc/PLUGINS/src/sc-src/cam.h:41: error: forward declaration of ‘struct cPrg’sc/sasccam.cpp:83: error: ‘cPrgPid’ was not declared in this scopesc/sasccam.cpp:83: error: ‘pid’ was not declared in this scopesc/sasccam.cpp:83: error: expected type-specifier before ‘cPrgPid’sc/sasccam.cpp:83: error: expected ‘;’ before ‘cPrgPid’sc/sasccam.cpp:84: error: invalid use of incomplete type ‘struct cPrg’sc/PLUGINS/src/sc-src/cam.h:41: error: forward declaration of ‘struct cPrg’make: *** [objs/sasccam.o] Błąd 1

**[Mesiu](#3078 "2011-10-05 07:39:20"):** Witam, tak przypadkiem natrafiłem na ten fajny opis, bo chciałem ponownie wrócić do opensascng, ale niestety on już od dawna nie jest rozwijany. Mam pytanie z bardzo innej beczki. Może ktoś wie dlaczego różne aplikacje przy skanowaniu satelity znajdują różną liczbę kanałów? Od czego to może zależeć?

