# zalas.pl

[![Build Status](https://travis-ci.org/jakzal/www.zalas.pl.svg?branch=source)](https://travis-ci.org/jakzal/www.zalas.pl)

To build the site locally you can use the provided docker configuration.

    bin/drun build
    bin/drun help

## Install dependencies

    bin/drun composer install --prefer-dist

## Run the sculpin generator

    bin/drun sculpin

If you prefer to tweak the command:

    bin/drun sculpin ./vendor/bin/sculpin generate --server --watch
