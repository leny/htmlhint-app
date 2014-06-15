"use strict"

module.exports = ( grunt ) ->

  require( "matchdep" ).filterDev( "grunt-*" ).forEach grunt.loadNpmTasks

  grunt.initConfig
    bumpup: "src/manifest.json"
    clean:
      bin: [ "bin" ]
      build: [ "builds/releases" ]
      releases: [ "releases" ]
    copy:
      manifest:
        src: "src/manifest.json"
        dest: "bin/package.json"
      assets:
        expand: yes
        src: [ "assets/**/*" ]
        cwd: "src/"
        dest: "bin/"
      vendors:
        expand: yes
        src: [ "vendors/**/*" ]
        cwd: "src/js/"
        dest: "bin/js/"
    markdown:
      credits:
        files: [
          src: "src/about.md"
          dest: "bin/about.html"
        ]
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
        options:
          bare: yes
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
    "install-dependencies":
      options:
        cwd: "bin"
    nodewebkit:
      options:
        build_dir: "builds"
        app_name: "Mikwoskòp - HTMLHint"
        mac: yes
        mac_icns: "bin/assets/icons/icon.icns"
        credits: "bin/about.html"
        win: yes
        linux32: no
        linux64: no
      src: "bin/**/*"
    rename:
      releases:
        files: [
          src: "builds/releases/Mikwoskòp - HTMLHint/"
          dest: "releases/"
        ]
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
    "build"
  ]

  grunt.registerTask "work", [
    "watch"
  ]

  grunt.registerTask "build", [
    "clean"
    "bumpup:prerelease"
    "copy:manifest"
    "copy:vendors"
    "copy:assets"
    "markdown"
    "jade"
    "stylus"
    "coffeelint"
    "coffee"
    "install-dependencies"
    "nodewebkit"
    "rename:releases"
    # "clean:bin"
    # "clean:build"
  ]
