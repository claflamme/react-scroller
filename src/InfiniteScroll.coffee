React = require 'react'

module.exports = React.createClass

  currentPage: 1

  getDefaultProps: ->

    {
      page: 1
      continue: false
      load: ->
      threshold: 100
      container: window
    }

  componentDidMount: ->

    @currentPage = @props.page

    @props.load @currentPage

  componentDidUpdate: ->

    @addListener()

  componentWillUnmount: ->

    @removeListener()

  render: ->

    return React.createElement 'div', null, @props.children

  getContainerOffset: ->

    scroll = @props.container.pageYOffset or @props.container.scrollTop
    height = @props.container.innerHeight or @props.container.offsetHeight

  getContainerHeight: ->

    return @props.container.innerHeight or @props.container.offsetHeight

  getContainerScrollPos: ->

    return @props.container.pageYOffset or @props.container.scrollTop

  scrollListener: ->

    scroller = React.findDOMNode @

    scrollerOffset = scroller.scrollTop + scroller.offsetHeight
    containerOffset = @getContainerScrollPos() + @getContainerHeight()

    if (scrollerOffset - containerOffset) < Number(@props.threshold)
      @removeListener()
      @props.load ++@currentPage

  addListener: ->

    unless @props.continue
      return

    @props.container.addEventListener 'scroll', @scrollListener
    @props.container.addEventListener 'resize', @scrollListener

    @scrollListener()

  removeListener: ->

    @props.container.removeEventListener 'scroll', @scrollListener
    @props.container.removeEventListener 'resize', @scrollListener
