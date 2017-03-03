title: Zaciemnianie kodu
link: http://www.zalas.pl/zaciemnianie-kodu
author: admin
description: 
post_id: 21
created: 2007/01/02 23:46:00
created_gmt: 2007/01/02 22:46:00
comment_status: open
post_name: zaciemnianie-kodu
status: publish
post_type: post

<!--Zaciemnianie kodu (code obfuscation) to proces czyniący go trudnym do przeczytania i zrozumienia, jednak pozostawiający nadal wykonywalnym. Perl ze swoimi zwariowanymi możliwościami składniowymi idealnie nadaje się do takich zabaw.-->

# Zaciemnianie kodu

Zaciemnianie kodu ([code obfuscation](http://en.wikipedia.org/wiki/Obfuscated_code)) to proces czyniący go trudnym do przeczytania i zrozumienia, jednak pozostawiający nadal wykonywalnym. [Perl](http://pl.wikipedia.org/wiki/Perl) ze swoimi [zwariowanymi możliwościami składniowymi](http://bash.org.pl/69677/) idealnie nadaje się do takich [zabaw](http://en.wikipedia.org/wiki/Obfuscated_Perl_contest). [Yet Another Obfuscation Engine](http://www.perlmonks.com/index.pl?node_id=161087) (yaoe.pl) jest jednym z zaciemniaczy tworzącym nawet z prostego skryptu pozornie bezsensowny ciąg znaków. Spotkałem się z tym po raz pierwszy trochę ponad rok temu, kiedy to firma [Strange Logic](http://www.strangelogic.com) szukała nowych programistów. Otrzymałem link do strony [www.hackpoland.com](http://www.hackpoland.com), gdzie znajdował się skrypt zaciemniony tą metodą (aby się tego dowiedzieć wystarczyło zapytać [google](http://www.google.com) \- powstały kod jest dosyć charakterystyczny). Uruchamiając go można było poczytać więcej na temat firmy oraz wyzwania jakie stawia osobom, które chciałyby dla niej pracować. Wydał mi się to bardzo dobry sposób na poszukiwanie nowych pracowników :) W wyzwaniu chodziło o to, aby odnaleźć zaszyty w kodzie komentarz z odnośnikiem do strony internetowej z dalszymi intstrukcjami ;) Napisałem 'odciemniacz' kodu zaciemnionego przez [yaoe.pl](http://www.perlmonks.com/index.pl?node_id=161087). Skrypt powinien odwrócić proces zaciemniania przynajmniej tak, aby można było odczytać pierwotny kod (prawdopodobnie nie zawsze da się potem uruchomić). 
    
    
    #!/usr/bin/perl
    #Deobfuscates perl code (obfuscaded by Yet Another Obfuscation Engine)
    #author: Jakub Zalas <jakub@zalas.net>
    #version: 20061230
    #first version: 2005
    #licence: GPL
    use strict;
    use warnings;
    
    die "Usage:\n\t$0 file_name_to_deobfuscate.pl\n" if !defined($ARGV[0]);
    my $fileName = $ARGV[0];
    
    my %code = (
        "\t"   => "chr oct ord w",
        "\n"   => "chr hex a",
        ' '    => "chr oct hex ffa",
        '!'    => "chr hex hex hex f",
        '"'    => "chr oct oct hex ceaa",
        '#'    => "chr oct hex abaa",
        '$'    => "chr oct hex afaa",
        '%'    => "chr oct oct hex daaa",
        '&'    => "chr hex oct hex cda",
        "'"    => "chr oct hex baba",
        '('    => "chr hex oct hex daa",
        ')'    => "chr oct hex caaa",
        '*'    => "chr oct hex ceaa",
        '+'    => "chr oct sqrt hex afa",
        ','    => "chr oct sqrt hex baa",
        '-'    => "chr oct hex daaa",
        '.'    => "chr oct hex ddea",
        '/'    => "chr oct sqrt hex cba",
        0      => "oct a",
        1      => "m mm",
        2      => "int log hex a",
        3      => "int sqrt hex a",
        4      => "int log ord a",
        5      => "int log hex aa",
        6      => "chr sqrt hex baa",
        7      => "int log hex aaa",
        8      => "int oct ord l",
        9      => "int oct ord w",
        ':'    => "chr oct oct ord n",
        ';'    => "chr sqrt hex daa",
        '<'    => "chr oct oct ord p",
        '='    => "chr sqrt hex eaa",
        '>'    => "chr oct oct ord r",
        '?'    => "chr sqrt hex faa",
        '@'    => "chr oct ord d",
        '['    => "chr oct oct hex cd",
        "\\"   => "chr oct oct hex ce",
        ']'    => "chr oct oct hex cf",
        '^'    => "chr oct hex hex dfa",
        _      => "chr log sqrt exp hex be",
        '`'    => "chr hex oct oct ord p",
        '{'    => "chr oct hex ad",
        '|'    => "chr oct hex ae",
        '}'    => "chr oct hex af",
        '~'    => "chr oct oct hex ord h",
    );
    my %decode = ();
    foreach my $key ( keys( %code ) ) {
    	$decode{$code{$key}} = $key;
    }
    
    undef $/;
    open FILE, "<$fileName";
    my $file = <FILE>;
    close FILE;
    
    $file =~ s/\s+/ /g;
    
    my @tmp = split("eval if ", $file);
    my @part1 = split(" x ", $tmp[0]);
    my @part2 = split(" x ", $tmp[1]);
    undef @tmp;
    
    my $count=0;
    while($count<2) {
    	my $repeat=1;
    	my @part;
    	@part = @part1 if $count==0;
    	@part = @part2 if $count==1;
    
    	for(my $i=$#part; $i>=0; $i--) {
    		my $row = $part[$i];
    
    		#in obfuscator repeating characters are being replaced
    		#by the sequence from the following regexp
    		if($row =~ /^s zzchr ordze(\s+|$)/) {
    			$repeat++;
    			next;
    		}
    
    		#decode
    		if($row =~ /s zz(.*?)ze/ && defined($decode{$1})) {
    			my $entity = $1;
    			$row =~ s/s zz${entity}ze/$decode{$entity}/
    		}
    
    		$row =~ s/s zzucfirst (.*?)ze/\u$1/ or
    		$row =~ s/s zzuc q y(.*?)yze/\U$1\L/ or
    		$row =~ s/s zzuc (.*?)ze/\U$1\L/ or
    		$row =~ s/s aaucfirst (.*?)ae/\u$1/ or
    		$row =~ s/s aauc (.*?)ae/\U$1\L/ or
    		$row =~ s/s zz(.*?)z/$1/ or
    		$row =~ s/s aa(.*?)a/$1/;
    
    		$row =~ s/q (y|b)(.*?)\1/$2/gi;
    
    		print $row for 1 .. $repeat;
    
    		$repeat = 1;
    	}
    
    	$count++;
    }
    
    1;