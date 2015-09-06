React = require 'react'

{DOM} = React

module.exports = React.createFactory React.createClass
  render: ->
    DOM.section
      className: 'content login-form'
    ,
      DOM.h1 null, 'Login!'
      DOM.p null,
        DOM.form
          method: 'post'
          action: '/admin/login'
        ,
          DOM.input
            type: 'hidden'
            name: 'redirectUrl'
            defaultValue: @props.redirectUrl
          , ''
          DOM.table null,
            DOM.tr null,
              DOM.td null,
                DOM.strong null, 'User name:'
              DOM.td null,
                DOM.input
                  name: 'userName'
                  initialValue: @props.userName
                , ''
            DOM.tr null,
              DOM.td null,
                DOM.strong null, 'Password:'
              DOM.td null,
                DOM.input
                  type: 'password'
                  name: 'password'
                , ''
            DOM.tr null,
              DOM.td null, ''
              DOM.td null,
                DOM.input
                  type: 'submit'
                  value: 'Login'
                , ''
