scrollerComponent = (React) ->

  React.createClass

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

    componentWillReceiveProps: (nextProps)->

      # If the page prop is updated, reset the internal counter.
      if nextProps.page
        @currentPage = nextProps.page

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

      unless @props.continue and @props.container
        return

      @props.container.addEventListener 'scroll', @scrollListener
      @props.container.addEventListener 'resize', @scrollListener

      @scrollListener()

    removeListener: ->

      unless @props.container
        return

      @props.container.removeEventListener 'scroll', @scrollListener
      @props.container.removeEventListener 'resize', @scrollListener

module.exports = scrollerComponent
