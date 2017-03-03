---
title: Instalacja Oracle 10g w Gentoo
slug: instalacja-oracle-10g-w-gentoo-czesc-1
author: Jakub Zalas
description: 
post_id: 25
created: 2007/07/31 22:19:52
created_gmt: 2007/07/31 21:19:52
comment_status: open
post_name: instalacja-oracle-10g-w-gentoo-czesc-1
status: publish
post_type: post
---

<!--Oracle wspiera instalację swojej bazy danych tylko na niektórych dystrybucjach (np RedHat, SUSE). Wystarczy jednak odpowiednio przygotować system, aby dział na praktycznie każdej nowoczesnej dystrybucji. Przedstawiam opis bazujący na Gentoo, ale w podobny sposób zrobiłem to w Fedorze.
-->

# Instalacja Oracle 10g w Gentoo

[Oracle](http://pl.wikipedia.org/wiki/Oracle_%28baza_danych%29) wspiera instalację swojej bazy danych tylko na niektórych dystrybucjach (np [RedHat](http://www.redhat.com/), [SUSE](http://www.novell.com/linux/)). Wystarczy jednak odpowiednio przygotować system, aby dział na praktycznie każdej nowoczesnej dystrybucji. Przedstawiam opis bazujący na [Gentoo](http://www.gentoo.org), ale w podobny sposób zrobiłem to w [Fedorze](http://fedoraproject.org/). 

## Użytkownik oracle

System bazy danych uruchamiany będzie z uprawnieniami specjalnego użytkownika (oracle), którego musimy dodać samodzielnie. Utworzymy też grupy oinstall (dla użytkowników utrzymujących instalację [Oracle](http://pl.wikipedia.org/wiki/Oracle_%28baza_danych%29)'a) i dba (dla administratorów bazy danych). Oczywiście wszystkie operacje wykonujemy z konta root: 
    
    
    mephisto ~ $  groupadd dba
    mephisto ~ $  groupadd oinstall
    mephisto ~ $  useradd -m -g oinstall -G dba -d /opt/oracle oracle
    mephisto ~ $  passwd oracle

## Sprostając wymaganiom

W poniższej tabeli zestawione są minimalne wartości parametrów jądra, których wymaga [Oracle](http://pl.wikipedia.org/wiki/Oracle_%28baza_danych%29) 10g. W ostatniej kolumnie znajduje się polecenie go sprawdzające. 

Parametr Minimalna wartość Polecenie sprawdzające

shmmax
2147483648
cat /proc/sys/kernel/shmmax

shmmni
4096
cat /proc/sys/kernel/shmmni

shmall
2097152
cat /proc/sys/kernel/shmall

shmmin
1
ipcs -lm |grep "min seg size"

semmsl
250
awk '{print $1}' /proc/sys/kernel/sem

semmns
32000
awk '{print $2}' /proc/sys/kernel/sem

semopm
100
awk '{print $3}' /proc/sys/kernel/sem

semmni
128
awk '{print $4}' /proc/sys/kernel/sem

file-max
65536
cat /proc/sys/fs/file-max

ip_local_port_range
1024 65000
cat /proc/sys/net/ipv4/ip_local_port_range
W moim przypadku wszystkie parametry posiadały minimum wymaganych wartości. Gdyby tak nie było lub nie satysfakcjonuje nas minimum, można je wszystkie zmienić w pliku _/etc/sysctl.conf_. 
    
    
    kernel.shmall = 2097152
    kernel.shmmax = 2147483648
    kernel.shmmni = 4096
    kernel.sem = 250 32000 100 128
    fs.file-max = 65536
    net.ipv4.ip_local_port_range = 1024 65000

Zmiany zostaną zastosowane po restarcie komputera lub wydaniu polecenia '_sysctl -p_'. 

## Przekraczając limity

Oprócz dostosowania parametrów jądra musimy także podnieść użytkownikowi oracle limity jednocześnie otwartych deskryptorów plików i liczby uruchomionych procesów. Pozwolą nam na to odpowiednie wpisy w pliku _/etc/security/limits.conf_: 
    
    
    oracle               soft     nofile   4096
    oracle               hard    nofile   63536
    oracle               soft     nproc   2047
    oracle               hard    nproc   16384

Należy się też upewnić, że _pam_limits_ jest skonfigurowane w _/etc/pam.d/system-auth_: 
    
    
    session required /lib/security/pam_limits.so
    session required /lib/security/pam_unix.so

Dzięki temu użytkownik oracle będzie mógł‚ podnieść swoje limity aż do górnej granicy (hard) przy pomocy '_ulimit -n 63536_' (deskryptory plików) i '_ulimit -u 16384_' (liczba uruchomionych procesów). Po wydaniu tych poleceń możemy upewnić się o zastosowanych zmianach w następujący sposób: 
    
    
    oracle@mephisto ~/ $ ulimit -n -u
    open files                      (-n) 63536
    max user processes        (-u) 16384

Aby powyższe parametry były ustalane przy starcie systemu dodamy krótki skrypt do _/etc/profile.d/oracle.sh_ lub _/etc/profile_, w którym zwiększymy limity tylko interesującemu nas użytkownikowi: 
    
    
    if [ $USER = "oracle" ]; then
    ulimit -u 16384 -n 63536;
    fi

## Lepiej zapobiegać

Na moim systemie instalator krzyczał, że brakuje mu pliku _libstdc++.so.5_. Plik ten miałem, ale w innym miejscu niż spodziewał się tego instalator (_/usr/lib/libstdc++-v3/_ zamiast _/usr/lib/_). Utworzenie linku symbolicznego pomogło: 
    
    
    ln -s /usr/lib/libstdc++-v3/libstdc++.so.5 /usr/lib/libstdc++.so.5

## Środowisko

Na koniec konfiguracji ustawimy jeszcze kilka zmiennych środowiskowych dla oracle'a (w pliku _/etc/env.d/99oracle_). 
    
    
    ORACLE_BASE=/opt/oracle
    ORACLE_HOME=/opt/oracle/product/10.2.0
    ORACLE_SID='esme'
    ORACLE_TERM=xterm
    ORACLE_OWNER=oracle
    TNS_ADMIN=/opt/oracle/product/10.2.0/network/admin
    NLS_LANG=POLISH_POLAND.EE8ISO8859P2
    ORA_NLS10=/opt/oracle/product/10.2.0/nls/data
    CLASSPATH=/opt/oracle/product/10.2.0/jdbc/lib/classes12.zip
    LD_LIBRARY_PATH=/opt/oracle/product/10.2.0/lib:/opt/oracle/product/10.2.0/lib32
    DISABLE_HUGETLBFS=1
    PATH=/opt/oracle/product/10.2.0/bin
    ROOTPATH=/opt/oracle/product/10.2.0/bin
    LDPATH=/opt/oracle/product/10.2.0/lib:/opt/oracle/product/10.2.0/lib32
    TZ=GMT

Oprócz dostosowania powyższych ścieżek do własnych preferencji powinniśmy również zdefiniować SID instancji naszej bazy dancyh (ORACLE_SID). Korzystać z tych zmiennych będzie nie tylko działająca instancja oracle'a, ale także instalator.

## Comments

**[xis](#2026 "2007-08-01 11:52:46"):** No, no :) Długa przerwa w pisaniu, ale tym jednym postem nadrobiłeś ;) Tylko dlaczego nie udostępniłeś ebuilda? :P

**[Jakub Zalas](#2033 "2007-08-01 15:35:43"):** Nie pisałem ebuilda :P ten opis to tylko przygotowanie środowiska, aby instalator ruszył bez większych komplikacji ;)

