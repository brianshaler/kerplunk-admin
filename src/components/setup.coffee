React = require 'react'

{DOM} = React

module.exports = React.createFactory React.createClass
  render: ->
    DOM.section
      className: 'content admin-panel'
    ,
      DOM.h1 null, 'Setup User Account'
      DOM.p null, 'Set up a user name and password.'
      DOM.p null,
        DOM.form
          method: 'post'
          action: '/admin/setup/0'
        ,
          DOM.table null,
            DOM.tr null,
              DOM.td null,
                DOM.strong null, 'User name:'
              DOM.td null,
                DOM.input
                  name: 'settings[userName]'
                  value: @props.userName
                , ''
            DOM.tr null,
              DOM.td null,
                DOM.strong null, 'Password:'
              DOM.td null,
                DOM.input
                  type: 'password'
                  name: 'settings[password]'
                , ''
            DOM.tr null,
              DOM.td null, ''
              DOM.td null,
                DOM.input
                  type: 'submit'
                  value: 'Login'
                , ''
