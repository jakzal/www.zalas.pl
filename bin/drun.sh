#!/bin/bash

set -e
set -u
set -o pipefail

COMMAND=${1:-"help"}

function build() {
    docker build -t zalas.pl/php ./docker/php/
}

function sculpin() {
    docker run -it --rm \
        -v $(pwd):/zalas.pl \
        -v $HOME/.composer/cache:/root/.composer/cache \
        -w /zalas.pl \
        -p 8000:8000 \
        zalas.pl/php \
         ${@:-./vendor/bin/sculpin generate --server --watch}
}

function php() {
    run zalas.pl/php php ${@:-"-v"}
}

function sh() {
    run zalas.pl/php ${@:-"sh"}
}

function composer() {
    run zalas.pl/php composer ${@:-""}
}

function run() {
    container=${1:-""}
    command=${@:2}
    if [ "" == "$container" ]; then
      echo "Usage: $0 container_name [command]"
      exit 1
    fi
    if [ "" == "$command" ]; then
      command=sh
    fi
    docker run -it --rm \
        -v $(pwd):/zalas.pl \
        -v $HOME/.composer/cache:/root/.composer/cache \
        -w /zalas.pl \
        $container $command
}

function help() {
    USAGE="$0 "$(compgen -A function | tr "\\n" "|" | sed 's/|$//')
    echo $USAGE
}

if [ "$(type -t $COMMAND)" != "function" ]; then
    help
    exit 1
fi

$COMMAND ${@:2}
