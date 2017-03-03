title: Przegląd klas, metod i zmiennych w vimie z pluginem TagList
link: http://www.zalas.pl/przeglad-klas-metod-i-zmiennych-w-vimie-z-pluginem-taglist
author: admin
description: 
post_id: 623
created: 2010/05/22 19:35:11
created_gmt: 2010/05/22 18:35:11
comment_status: open
post_name: przeglad-klas-metod-i-zmiennych-w-vimie-z-pluginem-taglist
status: publish
post_type: post

<!--Plugin TagList dodaje do vima funkcjonalność przeglądania listy klas, metod, zmiennych i innych słów kluczowych indeksowanych przez ctags. TagList pokazuje tagi w kontekście edytowanych plików i grupuje je po typie. Do tagów możemy skakać, otwierać je w nowym oknie lub zakładkach.-->

# Przegląd klas, metod i zmiennych w vimie z pluginem TagList

[Plugin TagList](http://vim.sourceforge.net/scripts/script.php?script_id=273) dodaje do vima funkcjonalność przeglądania listy klas, metod, zmiennych i innych słów kluczowych indeksowanych przez [ctags](/skakanie-do-definicji-klas-metod-i-zmiennych-w-vimie-przy-pomocy-exuberant-ctags). **TagList** pokazuje tagi w kontekście edytowanych plików i grupuje je po typie. Do tagów możemy skakać, otwierać je w nowym oknie lub zakładkach. ![Plugin TagList w vim](/uploads/wp//2010/05/vim-taglist-plugin-400x286.jpg)

## Instalacja

Jak zwykle pobieramy źródła ze [strony pluginów vima](http://www.vim.org/scripts/script.php?script_id=273) i rozpakowujemy je do katalogu _~/.vim_. Dodatkowo warto utworzyć indeks plików pomocy. W tym celu otwieramy vima i wpisujemy: 
    
    
    :helptags ~/.vim/doc

Teraz po wpisaniu w edytorze _:help taglist.txt_ uzyskamy pomoc na temat pluginu. **Uwaga**: Plugin TagList używa indeksu generowanego przez [exuberant ctags](http://ctags.sourceforge.net), który musimy najpierw wygenerować. Wyjaśniłem jak to zrobić w artykule "[Skakanie do definicji klas, metod i zmiennych w vimie przy pomocy exuberant ctags](/skakanie-do-definicji-klas-metod-i-zmiennych-w-vimie-przy-pomocy-exuberant-ctags)". 

## Użycie

Okno TagList otwieramy wpisując: 
    
    
    :TlistToggle

Wpisanie polecenia ponownie lub wciśnięcie **q** zamknie okno. Oczywiście bezustanne wpisywanie komend nie jest ani wygodne, ani wydajne. Dużo lepiej jest używać skrótów. Aby zmapować polecenie na **ctrl+l** dodajemy poniższą definicję do pliku _~/.vimrc_: 
    
    
    nmap <silent> <c-l> :TlistToggle

## Konfiguracja

TagList posiada wiele opcji konfiguracyjnych, które możemy ustawić w _~/.vimrc_, aby dostosować plugin do swoich preferencji. Ich przegląd dostępny jest w pliku pomocy: 
    
    
    :help taglist.txt

Osobiście skonfigurowałem sobie tytuł okna tak, aby zawierał nazwę pliku i słowo kluczowe nad którym jest aktualnie kursor: 
    
    
    set title titlestring=%<%f\ %([%{Tlist_Get_Tagname_By_Line()}]%)

Ustawiłem także kilka innych opcji, aby dostroić TagList do swoich potrzeb: 
    
    
    let Tlist_Use_Horiz_Window=0
    let Tlist_Use_Right_Window = 1
    let Tlist_Compact_Format = 1
    let Tlist_Exit_OnlyWindow = 1
    let Tlist_GainFocus_On_ToggleOpen = 1
    let Tlist_File_Fold_Auto_Close = 1
    let Tlist_Inc_Winwidth = 0
    let Tlist_Close_On_Select = 1
    let Tlist_Process_File_Always = 1