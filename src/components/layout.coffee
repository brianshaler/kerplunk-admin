_ = require 'lodash'
React = require 'react'

{DOM} = React

module.exports = React.createFactory React.createClass
  render: ->
    DOM.div
      style:
        border: 'solid 1px #000'
    ,
      #DOM.h1 {}, 'Not a real layout.'
      @props.contentComponent _.extend {}, @props
