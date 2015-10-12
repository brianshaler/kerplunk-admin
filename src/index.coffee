{EventEmitter} = require 'events'
crypto = require 'crypto'

_ = require 'lodash'

Setup = require './setup'
Login = require './login'

hash = require './hash'
generateSessionKey = require './generateSessionKey'
generateToken = require './generateToken'

logout = (req, res) ->
  req.session.destroy()
  res.redirect '/'

module.exports = (System) ->
  loginHandler = Login System
  setupHandler = Setup System
  homePage = {}

  routes:
    admin:
      '/admin/logout': 'logout'
      '/admin/settings': 'settings'
      '/admin': 'main'
    public:
      '/admin/login': 'login'
      '/admin/setup/:step?': 'setup'

  handlers:
    setup: setupHandler
    login: loginHandler
    logout: logout
    index: loginHandler
    main: 'main'
    settings: (req, res, next) ->
      System.getSettings()
      .then (settings) ->
        if req.body.settings
          hp = req.body.settings.homePage
          settings.homePage = {} unless settings.homePage
          if hp?.plugin
            settings.homePage.plugin = hp.plugin
          if hp?.handler
            settings.homePage.handler = hp.handler
          System.setGlobal 'homePage.plugin', hp.plugin
          System.updateSettings settings
          .then System.reset
          .then ->
            return
            # settings
        else
          console.log 'no post, read-only'
          settings

      .then (settings) ->
        if settings
          homePage: _.extend {}, System.getGlobal('homePage'), settings.homePage
      .done (data) ->
        if data
          res.render 'settings', data
        else
          res.redirect '/admin/settings'
      , (err) ->
        next err

  globals:
    public:
      css:
        'kerplunk-admin:layout': 'kerplunk-admin/css/admin.css'
        'kerplunk-admin:main': 'kerplunk-admin/css/admin.css'
        'kerplunk-admin:login': 'kerplunk-admin/css/admin.css'
        'kerplunk-admin:setup': 'kerplunk-admin/css/admin.css'
      layout:
        default: 'kerplunk-admin:layout'
      nav:
        Admin:
          Settings:
            General: '/admin/settings'
      requirejs:
        paths:
          moment: '/plugins/kerplunk-admin/js/moment.min.js'
          jquery: '/plugins/kerplunk-admin/js/jquery-1.9.1.min.js'
    homePage: homePage

  sockets: [
    'admin'
    'admin2'
  ]

  init: (next) ->
    System.getSettings()
    .then (settings) ->
      _.extend homePage,
        layout: 'public.layout.default'
        plugin: 'kerplunk-admin'
        handler: 'index'
      , settings.homePage
      socket = System.getSocket 'kerplunk'

      socket.on 'receive', (spark, data) ->
        if data.echo
          spark.write data.echo
        if data.pleaseBroadcast
          console.log 'rebroadcasting', data.pleaseBroadcast
          socket.broadcast data.pleaseBroadcast

      next()
