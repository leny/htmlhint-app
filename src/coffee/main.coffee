"use strict"

global.$ = $

sOSName = require( "os-name" )().toLowerCase().split( " " ).join( "" )

HTMLHint = require( "htmlhint" ).HTMLHint
###
messages = HTMLHint.verify '<ul><li></ul>',
    'tag-pair': yes
###

$ ->
    $( "body" ).addClass sOSName

    alert $( "h1" ).text()
    alert "node: #{ process.version }"
    alert "os: #{ sOSName }"
