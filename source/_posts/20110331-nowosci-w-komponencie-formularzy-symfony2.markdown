---
title: Nowości w komponencie formularzy Symfony2
slug: nowosci-w-komponencie-formularzy-symfony2
author: Jakub Zalas
description: 
post_id: 822
created: 2011/03/31 06:20:21
created_gmt: 2011/03/31 05:20:21
comment_status: open
post_name: nowosci-w-komponencie-formularzy-symfony2
status: publish
layout: post
---

<!--Refaktoryzacja formularzy to ostatnia z wielkich zmian i najbardziej oczekiwany pull request w Symfony2. Prace nie są jeszcze w pełni skończone, ale kod jest gotowy do połączenia z główną gałęzią. Jak tylko zmiany zostaną zaakceptowane (lub odrzucone) możemy spodziewać się wydania bety.-->

# Nowości w komponencie formularzy Symfony2

![](/uploads/wp/2011/03/sflogo.png)Refaktoryzacja formularzy to ostatnia z wielkich zmian i najbardziej oczekiwany [pull request](https://github.com/symfony/symfony/pull/399) w Symfony2. Prace nie są jeszcze w pełni skończone, ale kod jest gotowy do połączenia z główną gałęzią. Jak tylko zmiany zostaną zaakceptowane (lub odrzucone) możemy spodziewać się **wydania bety**. Refaktoryzacja dotyczy głównie właściwego **wstrzykiwania zależności** i ich rozluźnienia wewnątrz komponentu. Ma to w największej mierze wpływ na sposób, w jaki będziemy tworzyć obiekty. Polecam przyjrzeć się [przykładowemu projektowi](https://github.com/beberlei/AcmePizzaBundle) i [fragmentom kodu na Gist](https://gist.github.com/883293). Nie mamy pewności, że poprawki zostaną zaakceptowane w obecnym stanie. Możliwe, że coś się jeszcze zmieni, ale postanowiłem już teraz przyjrzeć się nieco bliżej temu komponentowi. Jest kilka rzeczy, które bardzo polubiłem. Większość z nich itak wejdzie do stabilnego wydania Symfony. Tylko sposób w jaki tworzyć będziemy formularze jest niepewny. 

## Konfiguracja

Proces tworzenia formularza stał się bardziej konfiguracją, niż kompozycją widgetów znaną z symfony 1.x: 
    
    
    $form = $this->get('form.factory')
        ->createBuilder('form')
        ->add('name', 'text')
        ->add('price', 'money', array('currency' => 'USD'))
        ->getForm();

W przykładzie pobieramy najpierw fabrykę formularzy, po czym tworzymy budowniczego i używamy go do definicji pól formularza. Tym jaki obiekt zostanie utworzony zarządza kontener usług (DIC). Zauważmy, że żaden obiekt nie jest jawnie tworzony za pomocą konstruktora. 

## POPO

Formularze nie polegają na żadnych specjalnych obiektach modelu. Mogą współdziałać nawet z najprostszymi obiektami typu **Plain Old PHP Object**: 
    
    
    class Pizza
    {
        private $name = null;
    
        private $price = null;
    
        public function setName($name)
        {
            $this->name = $name;
        }
    
        public function getName()
        {
            return $this->name;
        }
    
        public function setPrice($price)
        {
            $this->price = $price;
        }
    
        public function getPrice()
        {
            return $this->price;
        }
    }

Jedyne co musimy zrobić, to przekazać obiekt do formularza: 
    
    
    $pizza = new Pizza();
    $pizza->setName('Capriciosa');
    $pizza->setPrice(35.00);
    
    $form->setData($pizza);

## Zgadywanie typów pól

Chociaż formularze mogą współdziałać z praktycznie dowolną klasą modelu, dużo zyskamy wiążąc je z klasami ORMa (lub ODMa). Formularze są na przykład w stanie odgadnąć typy pól, korzystając z modelu danych zdefiniowanych w Doctrine: 
    
    
    $form = $this->get('form.factory')
        ->createBuilder('form', 'product', array('data_class' => 'Acme\PizzeriaBundle\Entity\Pizza'))
        ->add('name')
        ->add('price');

Podanie opcji _data_class_ sprawi, że formularz zajrzy do definicji typów wskazanej klasy: 
    
    
    namespace Acme\PizzeriaBundle\Entity;
    
    /**
     * @orm:Entity
     * @orm:Table(name="pizzas")
     */
    class Pizza
    {
        /**
         * @orm:Column(type="string", length="255")
         */
        private $name = null;
    
        /**
         * @orm:Column(type="decimal", precision=2)
         */
        private $price = null;
    
        // ...
    }

## Walidacja

Walidacja nie jest już domeną formularzy. W końcu umieszczoną ją tam, gdzie naprawdę należy; w modelu. 
    
    
    class Pizza
    {
        /**
         * @assert:NotBlank(message="Name cannot be left blank")
         */
        private $name = null;
    
        /**
         * @assert:NotBlank(message="You have to give a price")
         * @assert:Min(0)
         */
        private $price = null;
    }

Sam formularz niewiele wie o walidacji. W razie potrzeby pyta model, czy ten zawiera prawidłowe dane. 

## Szablony

W symfony 1.x komponenty interfejsu (_widgets_) generowane są przez odpowiadające im klasy. Nie jest to najlepsze miejsce dla szablonów we frameworku MVC. W Symfony2 sytuacja znacząco się poprawiła. Możemy tworzyć specjalne szablony dla kontrolek, z których każda definiowana jest w osobnym bloku. Dzięki temu mamy możliwość przeciążyć tylko wybrane elementy, a nawet dodać nowe. Poniżej wkleiłem przykład szablonu twig z [dokumentacji Symfony](http://symfony.com/doc/2.0/book/forms/view.html#defining-the-html-representation): 
    
    
    {% block textarea_field %}
        <textarea {% display field_attributes %}>{{ field.displayedData }}</textarea>
    {% endblock textarea_field %}
    
    
    assert

** **

## Comments

**[xis](#3039 "2011-03-31 00:30:39"):** Bardzo podoba mi się pomysł na walidację w osobnych obiektach, które możemy połączyć z formularzem lub nie :) No i, jak pewnie każdy, cieszę się, że wywalono to "echowanie" kodu html w metodzie render() i zastąpiono ją templatkami.

**[Łukasz](#3040 "2011-04-13 05:59:11"):** Inicjatywa Symfony2 jest bardzo obiecująca, zwłaszcza annotacje zaczerpnięte z Javy EJB oraz Springa. Cieszę się, że powoli programiści PHP nie mają się czego wstydzić jeśli chodzi o rozwiązania typu IoC czy metaprogramowanie.Oczywiście duża w tym zasługa twórców Doctrine, ale integracja pomiędzy projektami cieszy na pewno

