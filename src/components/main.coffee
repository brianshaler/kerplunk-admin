_ = require 'lodash'
React = require 'react'

{DOM} = React

Item = React.createFactory React.createClass
  getInitialState: ->
    expanded: false

  toggle: (e) ->
    e.preventDefault()
    @setState
      expanded: !@state.expanded

  render: ->
    classes = ['admin-link']

    if @props.children.length > 0
      classes.push ''

    if @state.expanded
      classes.push 'expanded'
    else
      classes.push 'collapsed'

    if @state.active
      classes.push 'active'

    DOM.li
      className: classes.join ' '
    ,
      if @props.children.length > 0
        #console.log "ul-#{@props.text}-#{@props.href}"
        [
          DOM.a
            key: "a-#{@props.text}-#{@props.href}"
            href: '#'
            onClick: @toggle
          ,
            @props.text
          DOM.ul
            key: "ul-#{@props.text}-#{@props.href}"
            className: 'admin-links'
            style:
              display: ('block' if @state.expanded)
          ,
            _.map @props.children, (kid, index) =>
              Item _.extend {key: index}, @props, kid
        ]
      else
        DOM.a
          href: @props.href
          onClick: (e) =>
            @props.pushState e, true
        , @props.text

processItem = (item, text) ->
  href = if typeof item is 'string'
    item
  else
    '#'

  children = if typeof item is 'object'
    _.map item, processItem
  else
    null

  text: text
  href: href
  children: children ? []

module.exports = React.createFactory React.createClass
  getInitialState: ->
    items: @getItems @props

  getItems: (props = @props) ->
    _.map props.globals.public.nav, processItem

  componentWillReceiveProps: (newProps) ->
    @setState
      items: @getItems newProps

  render: ->
    DOM.section
      className: 'content'
    ,
      _.map @state.items, (item, index) =>
        DOM.section
          className: 'col-lg-4 col-md-6 admin-block'
          key: index
        ,
          DOM.div
            className: 'box box-info admin-panel'
          ,
            DOM.div
              className: 'box-header'
            ,
              DOM.em className: 'fa fa-gear'
              DOM.div
                className: 'box-title'
              ,
                item.text ? item.segment
            DOM.div
              className: 'box-body admin-panel-content'
            ,
              DOM.ul
                className: 'admin-links'
              ,
                _.map item.children, (item, index) =>
                  Item _.extend {key: index}, @props, item
