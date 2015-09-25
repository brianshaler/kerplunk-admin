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
    admin:
      '/admin/logout': 'logout'
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
          Settings: '/admin'
      requirejs:
        paths:
          moment: '/plugins/kerplunk-admin/js/moment.min.js'
          jquery: '/plugins/kerplunk-admin/js/jquery-1.9.1.min.js'
    homePage:
      layout: 'public.layout.default'
      plugin: 'kerplunk-admin'
      handler: 'index'

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
