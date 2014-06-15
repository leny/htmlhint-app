"use strict";
var version;

global.$ = $;

version = process.version;

$(function() {
  alert($("h1").text());
  return alert("node -v : " + version);
});
