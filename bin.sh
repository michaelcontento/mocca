#!/usr/bin/env bash

default_args() {
    local opts=''
    if [ -f .mocha.opts ]; then
        opts="${opts} --opts .mocha.opts"
    fi
    if [ -f .moccarc ]; then
        opts="${opts} --opts .moccarc"
    fi

    echo "--bail \
        --check-leaks \
        --compilers js:mocca/babel \
        --recursive \
        --reporter dot \
        --require mocca/bootstrap \
        --require mocha-clean \
        --throw-deprecation \
        --trace-deprecation \
        ${opts}"
}

mocha() {
    local npm2="./node_modules/mocca/node_modules/.bin/mocha"
    local npm3="./node_modules/.bin/mocha"

    if [ -x $npm2 ]; then
        $npm2 $(default_args) $@ './src/**/__tests__/*-test.js'
    elif [ -x $npm3 ]; then
        $npm3 $(default_args) $@ './**/__tests__/*-test.js'
    else
        echo "ERROR: Unable to locate mocha" >&2
        exit 1
    fi
}

mocha $@
