"use strict"

global.$ = $

pkg = require "./package.json"

sHTMLHintVersion = pkg.dependencies.htmlhint.replace( "^", "" )

sOSName = require( "os-name" )().toLowerCase().split( " " ).join( "" )

HTMLHint = require( "htmlhint" ).HTMLHint
fs = require "fs"
path = require "path"

aFiles = []

$fileTemplate = null
$reportTemplate = null
$results = null
$reloadLink = null

htmlEntities = ( sStr ) ->
    String sStr
        .replace /&/g, "&amp;"
        .replace /</g, "&lt;"
        .replace />/g, "&gt;"
        .replace /"/g, "&quot;"

lintFiles = ->
    $results.empty()
    $reloadLink.hide()
    iTotalErrors = 0
    oParameters = {}
    for oParam in $( "#params form" ).serializeArray()
        continue if oParam.value is "0"
        oParameters[ oParam.name ] = yes if oParam.value is "1"
        oParameters[ oParam.name ] = oParam.value if oParam.value
    for oFile in aFiles
        oFile.content = fs.readFileSync oFile.path, { encoding: "utf-8" }
        aErrors = HTMLHint.verify oFile.content, oParameters
        ( $file = $fileTemplate.clone() )
            .find "> strong"
                .text oFile.path
                .end()
            .find "> span"
                .text if ( iErrors = aErrors.length ) > 1 then "#{ iErrors } errors" else "#{ iErrors } error"
                .end()
            .appendTo $results
        iTotalErrors += iErrors
        $fileReportList = $file.find "ol"
        for oError in aErrors
            ( $error = $reportTemplate.clone() )
                .find "> span"
                    .text "line #{ oError.col }, column #{ oError.col }"
                    .end()
                .find "> code"
                    .html htmlEntities( oError.evidence ).trim().replace htmlEntities( oError.raw ), "<strong>#{ htmlEntities( oError.raw ) }</strong>"
                    .end()
                .find "> p"
                    .find "a"
                        .attr "href", oError.rule.link
                        .text "#{ oError.rule.id }: "
                        .end()
                    .find "span"
                        .text oError.message
                        .end()
                    .end()
                .appendTo $fileReportList
    $( "div.right h3 span" ).show().text " (#{ iTotalErrors } errors in #{ aFiles.length } files)"
    $reloadLink.show()

filesSelected = ( e ) ->
    aFiles = []
    for oFile in e.originalEvent.target.files
        aFiles.push
            path: oFile.path
    return lintFiles() if aFiles.length > 0
    alert "ERROR: You don't gave me any HTML file !"

$ ->
    $results = $ "#results"
    ( $reloadLink = $ "#reload" )
        .on "click", ( e ) ->
            e.preventDefault()
            lintFiles() if aFiles.length
    $fileTemplate = $( $( "#tpl-file" ).remove().text() )
    $reportTemplate = $( $( "#tpl-report" ).remove().text() )

    $( "body" ).addClass sOSName
    $( "header h2 span" ).text sHTMLHintVersion

    $( "#files a" ).on "click", ( e ) ->
        e.preventDefault()
        $( "#files input" ).trigger "click"

    $( "#files input" ).on "change", filesSelected

    # require( "nw.gui" ).Window.get().showDevTools()
