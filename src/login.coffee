hash = require './hash'
generateSessionKey = require './generateSessionKey'
generateToken = require './generateToken'

module.exports = (System) ->
  (req, res, next) ->
    console.log 'login..'
    if !System.isSetup()
      console.log 'redirecting.. /admin/setup', System.isSetup()
      return res.redirect '/admin/setup'
    redirectUrl = ''

    if req.isUser
      redirectUrl = '/admin'
      if req.query?.redirectUrl?.length > 0
        redirectUrl = req.query.redirectUrl
      return res.redirect redirectUrl

    displayOrRedirect = ->
      if redirectUrl == ''
        if req.query?.redirectUrl?.length > 0
          redirectUrl = req.query.redirectUrl
        console.log 'show login'
        res.render 'login',
          userName: if req.body.userName then req.body.userName else ''
          redirectUrl: redirectUrl
      else
        console.log 'redirecting to', redirectUrl
        res.redirect redirectUrl

    System.getSettingsByName 'kerplunk-server', (err, serverSettings) ->
      if req.body.userName and req.body.password
        throw err if err
        unless serverSettings?
          console.log "No serverSettings???", serverSettings
        return next() unless serverSettings? # not set up?
        redirectUrl = '/admin/login'

        {userName, password, sessionKey} = serverSettings

        if userName == req.body.userName and password == hash req.body.password
          if typeof req.body.redirectUrl == 'string' and req.body.redirectUrl.length > 0 and req.body.redirectUrl != "undefined"
            redirectUrl = req.body.redirectUrl
          else
            redirectUrl = '/admin'

          unless sessionKey?.length > 0
            sessionKey = generateSessionKey userName, password

          sessionToken = generateToken userName, sessionKey

          req.session.sessionKey = sessionKey
          req.session.sessionToken = sessionToken
          req.session.userName = userName
          #console.log "Setting flash..", userName, password
          #req.flash "Logged in!"
        else
          console.log 'Login failed'
        #  req.flash "Login failed"
      displayOrRedirect()
