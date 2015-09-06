hash = require './hash'
generateSessionKey = require './generateSessionKey'
generateToken = require './generateToken'

module.exports = (System) ->
  (req, res, next) ->
    console.log 'setup..', System.isSetup()
    return next() if System.isSetup()
    System.getSettingsByName 'kerplunk-server', (err, serverSettings) ->
      return next err if err
      System.getSettings (err, appSettings) ->
        return next err if err
        step = 0
        step = appSettings.setupStep if appSettings.setupStep?

        if parseInt(req.params.step) > 0
          step = parseInt req.params.step

        if step == 0
          if req.body?.settings?.userName and req.body.settings.password
            userName = req.body.settings.userName
            hashedPassword = hash req.body.settings.password
            sessionKey = generateSessionKey userName, hashedPassword
            sessionToken = generateToken userName, sessionKey

            req.session.sessionKey = sessionKey
            req.session.sessionToken = sessionToken
            req.session.userName = userName

            serverSettings.userName = userName
            serverSettings.password = hashedPassword
            serverSettings.sessionKey = sessionKey

            req.session.sessionKey = sessionKey
            req.session.sessionToken = sessionToken
            req.session.userName = userName

            step = 1
            appSettings.setupStep = step
            return System.updateSettingsByName 'kerplunk-server', serverSettings, (err) ->
              return next err if err
              System.updateSettings appSettings, (err) ->
                return next err if err
                #req.flash "User account created"
                res.redirect "/admin/setup/#{step}"

        if step == 0
          console.log 'render setup'
          res.render 'setup'
        else
          #req.flash 'Setup Complete!'
          console.log 'redirect /admin'
          res.redirect '/admin'
