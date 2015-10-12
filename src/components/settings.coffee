React = require 'react'

{DOM} = React

module.exports = React.createFactory React.createClass
  render: ->
    DOM.section
      className: 'content'
    ,
      DOM.h1 null, 'Settings'
      DOM.form
        method: 'post'
        action: '/admin/settings'
      ,
        DOM.p null, 'home page plugin and handler'
        DOM.p null,
          DOM.input
            name: 'settings[homePage][plugin]'
            placeholder: 'home page plugin'
            defaultValue: @props.homePage?.plugin
        DOM.p null,
          DOM.input
            name: 'settings[homePage][handler]'
            placeholder: 'home page handler'
            defaultValue: @props.homePage?.handler
        DOM.input
          type: 'submit'
          className: 'btn btn-success'
          value: 'save'
