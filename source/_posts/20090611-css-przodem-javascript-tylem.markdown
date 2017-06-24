---
title: CSS przodem, JavaScript tyłem
slug: css-przodem-javascript-tylem
author: Jakub Zalas
description: 
post_id: 222
created: 2009/06/11 15:20:01
created_gmt: 2009/06/11 14:20:01
comment_status: open
post_name: css-przodem-javascript-tylem
status: publish
layout: post
expired: true
comments: true
tags: [symfony]
---

Załączanie arkuszy styli CSS na górze strony, a skryptów JavaScript jak najpóźniej to tylko dwie z 34 dobrych praktyk opisanych przez Yahoo w [Best Practices for Speeding Up Your Website](http://developer.yahoo.com/performance/rules.html). Stosowanie się do nich pozwoli zmniejszyć wizualnie czas generowania strony w przeglądarce. Oto prosty przykład jak to osiągnąć w [symfony](http://www.symfony-project.org/). Za każdym razem gdy używamy funkcji pomocniczych _use_javascript_ i _use_stylesheet,_ skrypty i pliki CSS nie są od razu dodawane do kodu html strony. Za to zadanie odpowiedzialny jest filtr _sfCommonFilter_, który je wstrzykuje na końcu sekcji _head_ (chwilę przed elementem _</head>)_. Dzięki temu każdy plik jest dodawany tylko raz i wszystkie są w jednym miejscu. Filtr możemy jednak nieco usprawnić porzez zastosowanie się do opisanych we wstępie zaleceń Yahoo. Pliki CSS są już załączane na początku. Musimy tylko przenieść skrypty JavaScript na spód strony (chwilę przed tagiem _</body>_).  Aby to osągnąć wystarczy nadpisać klasę _sfCommonFilter_. Zmiany nie są poważne, użyłem oryginalnego kodu i lekko zmieniłem sposób w jaki skrypty są wstrzykiwane.
    
    
    class zCommonFilter extends sfFilter
    {
      public function execute($filterChain)
      {
        $filterChain->execute();
    
        $response = $this->context->getResponse();
    
        // include stylesheets
        $content = $response->getContent();
        if (false !== ($pos = strpos($content, '</head>')))
        {
          $this->context->getConfiguration()->loadHelpers(array('Tag', 'Asset'));
          $html = '';
          if (!sfConfig::get('symfony.asset.stylesheets_included', false))
          {
            $html.= get_stylesheets($response);
    
            if ($html)
            {
              $response->setContent(substr($content, 0, $pos) . $html . substr($content, $pos));
            }
          }
        }
    
        // include javascripts
        $content = $response->getContent();
        if (false !== ($pos = strpos($content, '</body>')))
        {
          $this->context->getConfiguration()->loadHelpers(array('Tag', 'Asset'));
          $html = '';
          if (!sfConfig::get('symfony.asset.javascripts_included', false))
          {
            $html.= get_javascripts($response);
    
            if ($html)
            {
              $response->setContent(substr($content, 0, $pos) . $html . substr($content, $pos));
            }
          }
        }
    
        sfConfig::set('symfony.asset.javascripts_included', false);
        sfConfig::set('symfony.asset.stylesheets_included', false);
      }
    }

Teraz trzeba  tylko "powiedzieć" symfony, aby  zamiast domyślnego filtru użyła naszego. Jak zawsze robimy to w pliku _filters.yml_ wybranej aplikacji (_apps/*/config/filters.yml_): 
    
    
    rendering: ~
    security:  ~
    cache:     ~
    
    common:
      class: zCommonFilter
    
    execution: ~
