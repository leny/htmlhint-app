"use strict"

module.exports = ( grunt ) ->

  require( "matchdep" ).filterDev( "grunt-*" ).forEach grunt.loadNpmTasks

  grunt.initConfig
    coffeelint:
      options:
        arrow_spacing:
          level: "error"
        camel_case_classes:
          level: "error"
        colon_assignment_spacing:
          spacing:
            left: 0
            right: 1
          level: "error"
        duplicate_key:
          level: "error"
        empty_constructor_needs_parens:
          level: "error"
        indentation:
          level: "ignore"
        max_line_length:
          level: "ignore"
        no_backticks:
          level: "error"
        no_empty_param_list:
          level: "error"
        no_stand_alone_at:
          level: "error"
        no_tabs:
          level: "error"
        no_throwing_strings:
          level: "error"
        no_trailing_semicolons:
          level: "error"
        no_unnecessary_fat_arrows:
          level: "error"
        space_operators:
          level: "error"
      src:
        files:
          src: [ "src/coffee/*.coffee" ]
    coffee:
      src:
        expand: yes
        cwd: "src/coffee"
        src: [ "*.coffee" ]
        dest: "bin/js"
        ext: ".js"
    stylus:
      options:
        compress: no
      styles:
        files:
          "bin/css/styles.css": "src/stylus/styles.styl"
    jade:
      options:
        compress: no
      page:
        files:
          "bin/index.html": "src/jade/index.jade"
    nodewebkit:
      options:
        build_dir: "./builds"
        app_name: "Mikwoskòp - HTMLHint"
        mac: yes
        mac_icns: no # TODO
        win: yes
        linux32: no
        linux64: no
      src: "./**/*"
    watch:
      jade:
        files: "src/jade/index.jade"
        tasks: [ "jade" ]
        options:
          livereload: yes
      styles:
        files: "src/stylus/styles.styl"
        tasks: [ "stylus" ]
        options:
          livereload: yes
      coffee:
        files: "src/coffee/*.coffee"
        tasks: [ "coffeelint", "coffee" ]
        options:
          livereload: yes

  grunt.registerTask "default", [
    "jade"
    "stylus"
    "coffeelint"
    "coffee"
  ]

  grunt.registerTask "work", [
    "jade"
    "stylus"
    "coffeelint"
    "coffee"
    "watch"
  ]

  grunt.registerTask "build", [
    "jade"
    "stylus"
    "coffeelint"
    "coffee"
    "nodewebkit"
  ]
