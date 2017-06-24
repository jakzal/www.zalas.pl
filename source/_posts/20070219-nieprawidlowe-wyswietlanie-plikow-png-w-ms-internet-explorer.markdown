---
title: Nieprawidłowe wyświetlanie plików PNG w MS Internet Explorer
slug: nieprawidlowe-wyswietlanie-plikow-png-w-ms-internet-explorer
author: Jakub Zalas
description: 
post_id: 23
created: 2007/02/19 22:31:55
created_gmt: 2007/02/19 21:31:55
comment_status: open
post_name: nieprawidlowe-wyswietlanie-plikow-png-w-ms-internet-explorer
status: publish
layout: post
expired: true
comments: true
tags: [web]
---

<!--Nie jeden webmaster klął na Microsoft&copy; za nieprawidłowe wyświetlanie przezroczystości plików PNG w przeglądarkach Internet Explorer - zamiast niej otrzymujemy szare tło. Jedyne co pozostaje to zastosować GIFa, który rzadko się do tego nadaje. Przezroczyste pliki GIF często są poszarpane, a ich jakość jest oczywiście niższa - to dlatego, że ich przezroczystość ma tylko 8 bitów. Myślałem, że tego nie da się obeść w inny sposób niż zaczekać aż IE będzie niszową, mało znaczącą przeglądarką, albo zostanie wypuszczona jego nowa, poprawiona wersja. A jednak...-->

# Nieprawidłowe wyświetlanie plików PNG w MS Internet Explorer

Nie jeden webmaster klął na Microsoft© za nieprawidłowe wyświetlanie przezroczystości plików [PNG](http://pl.wikipedia.org/wiki/Png) w przeglądarkach Internet Explorer - zamiast niej otrzymujemy szare tło. Jedyne co pozostaje to zastosować [GIF](http://pl.wikipedia.org/wiki/GIF)a, który rzadko się do tego nadaje. Przezroczyste pliki GIF często są poszarpane, a ich jakość jest oczywiście niższa - to dlatego, że ich przezroczystość ma tylko 8 bitów. Myślałem, że tego nie da się obeść w inny sposób niż zaczekać aż IE będzie niszową, mało znaczącą przeglądarką, albo zostanie wypuszczona jego nowa, poprawiona wersja. A jednak... Zostałem mile zaskoczony, gdy dowiedziałem się, że jest możliwe zmusić IE do prawidłowego pokazania plików PNG :D Do tego jest to bardzo proste i sprowadza się do wywołania specjalnego kodu JavaScript. Kod ten jest pomijany przez inne przeglądarki. Rozwiązanie niemal idealne ;) W osobnym pliku js umieszczamy poniższy kod: 
    
    
    /*
    Correctly handle PNG transparency in Win IE 5.5 & 6.
    http://homepage.ntlworld.com/bobosola. Updated 18-Jan-2006.
    Use in  with DEFER keyword wrapped in conditional comments:
    */
    var arVersion = navigator.appVersion.split("MSIE")
    var version = parseFloat(arVersion[1])
    if ((version >= 5.5) && (document.body.filters))
    {
       for(var i=0; i
       {
          var img = document.images[i]
          var imgName = img.src.toUpperCase()
          if (imgName.substring(imgName.length-3, imgName.length) == "PNG")
          {
             var imgID = (img.id) ? "id='" + img.id + "' " : ""
             var imgClass = (img.className) ? "class='" + img.className + "' " : ""
             var imgTitle = (img.title) ? "title='" + img.title + "' " : "title='" + img.alt + "' "
             var imgStyle = "display:inline-block;" + img.style.cssText
             if (img.align == "left") imgStyle = "float:left;" + imgStyle
             if (img.align == "right") imgStyle = "float:right;" + imgStyle
             if (img.parentElement.href) imgStyle = "cursor:hand;" + imgStyle
             var strNewHTML = "
             + " style=\"" + "width:" + img.width + "px; height:" + img.height + "px;" + imgStyle + ";"
             + "filter:progid:DXImageTransform.Microsoft.AlphaImageLoader"
             + "(src=\'" + img.src + "\', sizingMethod='scale');\">"
             img.outerHTML = strNewHTML
             i = i-1
          }
       }
    }

Natomiast w kodzie html strony umieszczamy jego warunkowe dołączenie: 
    
    
    <pre>
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    <html>
    <head>
    	<title>Prawidłowe wyświetlanie plików PNG w MS Internet Explorer</title>
    	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    	<!--[if lt IE 7.]>
    	<script defer type="text/javascript" src="pngfix.js"></script>
    	<![endif]-->
    </head>
    
    <body>
    
    Obrazki PNG zostaną poprawnie wyświetlone w tym dokumencie także w Internet Explorer.
    
    </body>
    </html>
    </pre>

To wszystko!! Od tej pory każdy dołączony do strony plik png będzie wyświetlony prawidłowo w każdej przeglądarce :) _Źródła:_

  * _[The PNG problem in Windows Internet Explorer](http://homepage.ntlworld.com/bobosola/index.htm)_
_ __ _
  * _[Normal display of PNG Alpha Transparency with MSIE](http://koivi.com/ie-png-transparency/)_
_ __ _
  * _[Poprawka wyświetlania plików PNG w IE](http://www.mambopl.com/content/view/136/48/)_
_ __ _
  * _[PNG - Jak i dlaczego używać](http://pornel.net/pnghowto)_
_ __ _
  * _[PNG Behavior](http://webfx.eae.net/dhtml/pngbehavior/pngbehavior.html)_
_ __ _
  * _[Improved PNG Behavior](http://www.scss.com.au/family/andrew/webdesign/pngbehavior/)[ ](http://dean.edwards.name/IE7/)_
_ __ _
  * _[JavaScriptowa biblioteka IE7](http://dean.edwards.name/IE7/)_
_____________ ____________________________ _
