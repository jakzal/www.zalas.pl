---
title: Parsowanie stron internetowych z użyciem sfWebBrowser i SimpleXML
slug: parsowanie-stron-internetowych-z-uzyciem-sfwebbrowser-i-simplexml
author: Jakub Zalas
description: 
post_id: 114
created: 2009/05/14 22:09:20
created_gmt: 2009/05/14 21:09:20
comment_status: open
post_name: parsowanie-stron-internetowych-z-uzyciem-sfwebbrowser-i-simplexml
status: publish
layout: post
expired: true
comments: true
tags: [symfony,php]
---

<!--sfWebBrowser to klasa emulująca wywołania przeglądarki internetwej. Dzięki niej możemy zaprogramować nawigację po stronie www przy pomocy przyjemnego, obiektowego interfejsu. Odpowiedź może zostać zwrócona jako element SimpleXML, co umożliwia wykonywanie zapytań xpath na parsowanym dokumencie. Niestety strony www rzadko są poprawnymi dokumentami XML. W większości przypadków sfWebBrowser raczej wyrzuci wyjątek, niż zwróci coś interesującego. Jest jednak sposób, aby temu zaradzić.-->

# Parsowanie stron internetowych z użyciem sfWebBrowser i SimpleXML

[sfWebBrowser](http://www.symfony-project.org/plugins/sfWebBrowserPlugin) to klasa emulująca wywołania przeglądarki internetowej. Dzięki niej możemy zaprogramować nawigację po stronie www przy pomocy przyjemnego, obiektowego interfejsu. Odpowiedź może zostać zwrócona jako element [SimpleXML](http://pl2.php.net/simplexml), co umożliwia wykonywanie zapytań xpath na parsowanym dokumencie. Z łatwością możemy dostać część strony, która nas interesuje przy pomocy prostego wywołania: 
    
    
    $xml->xpath('//table[@class="main"]//tr[@class="odd" or @class="even"]');

Niestety strony internetowe rzadko są poprawnymi dokumentami XML. W większości przypadków _sfWebBrowser_ raczej wyrzuci wyjątek, niż zwróci coś interesującego. Jest jednak sposób, aby temu zaradzić. Możemy nadpisać metodę _getResponseXML_, aby  utworzyła element klasy _SimpleXMLElement_ z dokumentu DOM, gdyby oryginalna metoda zawiodła. 
    
    
    <?php
    /*
     * (c) 2008 Jakub Zalas
     *
     * For the full copyright and license information, please view the LICENSE
     * file that was distributed with this source code.
     */
    
    /**
     * Web browser
     *
     * @package    zToolsPlugin
     * @subpackage lib
     * @author     Jakub Zalas <jakub@zalas.pl>
     * @version    SVN: $Id$
     */
    class zWebBrowser extends sfWebBrowser
    {
      /**
       * Returns response as XML
       *
       * If reponse is not a valid XML it is being created from
       * a DOM document which is being created from a text response
       * (this is the case for not valid HTML documents).
       *
       * @return SimpleXMLElement
       */
      public function getResponseXML()
      {
        try
        {
          $this->responseXml = parent::getResponseXML();
        }
        catch (Exception $exception)
        {
          $doc = new DOMDocument();
          $doc->loadHTML($this->getResponseText());
          $this->responseXml = simplexml_import_dom($doc);
        }
    
        return $this->responseXml;
      }
    }
