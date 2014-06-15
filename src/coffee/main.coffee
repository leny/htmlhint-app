"use strict"

global.$ = $

version = process.version

$ ->
    alert $( "h1" ).text()
    alert "node -v : #{ version }"
