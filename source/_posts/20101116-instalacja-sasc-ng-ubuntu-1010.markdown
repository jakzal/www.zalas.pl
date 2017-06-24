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

