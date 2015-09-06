{EventEmitter} = require 'events'
crypto = require 'crypto'

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

  routes:
    public:
      '/admin/login': 'login'
      '/admin/setup/:step?': 'setup'
    admin:
      '/admin/logout': 'logout'
      '/admin': 'main'

  globals:
    public:
      styles:
        'kerplunk-admin/css/admin.css': ['/admin/**', '/admin/']
      layout:
        default: 'kerplunk-admin:layout'
      nav:
        Admin:
          Settings: '/admin'
      requirejs:
        paths:
          moment: '/plugins/kerplunk-admin/js/moment.min.js'
          jquery: '/plugins/kerplunk-admin/js/jquery-1.9.1.min.js'
    homePage:
      layout: 'public.layout.default'
      plugin: 'kerplunk-admin'
      handler: 'index'

  handlers:
    setup: setupHandler
    login: loginHandler
    logout: logout
    index: loginHandler
    main: 'main'

  sockets: [
    'admin'
    'admin2'
  ]

  init: (next) ->
    homePage =
      layout: "public.layouts.admin"

    socket = System.getSocket 'kerplunk'

    socket.on 'receive', (spark, data) ->
      if data.echo
        spark.write data.echo
      if data.pleaseBroadcast
        console.log 'rebroadcasting', data.pleaseBroadcast
        socket.broadcast data.pleaseBroadcast

    next()
