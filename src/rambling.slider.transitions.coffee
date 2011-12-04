(($) ->
  allAroundTransitions = [
    { name: 'sliceUp', helper: 'slideUpSlices' },
    { name: 'sliceDown', helper: 'slideDownSlices' },
    { name: 'sliceUpDown', helper: 'slideUpDownSlices' },
    { name: 'sliceFade', helper: 'fadeSlices' },
    { name: 'fold', helper: 'foldSlices' },
  ]

  allAroundTransitions.suffixes = [
    { name: 'Right', sorter: undefined },
    { name: 'Left', sorter: $.fn.reverse },
    { name: 'OutIn', sorter: $.fn.sortOutIn },
    { name: 'InOut', sorter: $.fn.sortInOut },
    { name: 'Random', sorter: $.fn.shuffle },
  ]

  boxTransitions = [
    { name: 'boxRain', helper: 'rainBoxes' },
    { name: 'boxGrow', helper: 'growBoxes' },
  ]

  boxTransitions.suffixes = [
    { name: '', sorter: undefined },
    { name: 'Reverse', sorter: $.fn.reverse },
    { name: 'OutIn', sorter: $.fn.sortOutIn },
    { name: 'InOut', sorter: $.fn.sortInOut },
    { name: 'Random', sorter: $.fn.shuffle },
  ]

  transitions = [allAroundTransitions, boxTransitions]

  animationFullImageOptions =
    fadeIn: (slider) ->
      @css height: '100%', width: slider.width(), position: 'absolute', top: 0, left: 0
      {opacity: '1'}
    fadeOut: (slider) ->
      @css height: '100%', width: slider.width(), position: 'absolute', top: 0, left: 0
      {opacity: '1'}
    rolloverRight: ->
      @css height: '100%', width: 0, opacity: '1'
      return
    rolloverLeft: (slider, settings) ->
      @css height: '100%', width: 0, opacity: '1', left: 'auto', right: '0px'
      @find('img').css(left: "#{-slider.width()}px").animate {left: '0px'}, settings.speed * 2
      {width: slider.width()}
    slideInRight: (slider, settings) ->
      @css height: '100%', width: 0, opacity: '1'
      @find('img').css(left: "#{-slider.width()}px").animate {left: '0px'}, settings.speed * 2
      {width: slider.width()}
    slideInLeft: (slider) ->
      self = @
      self.css height: '100%', width: 0, opacity: '1', left: 'auto', right: '0px'
      finishedHandler = ->
        self.css left: '0px', right: 'auto'
        slider.unbind 'rambling:finished', finishedHandler
      slider.bind 'rambling:finished', finishedHandler
      return

  flashSlideIn = (beforeAnimation, animateStyle, afterAnimation) ->
    self = @
    self.currentSlideElement.css beforeAnimation
    window.setTimeout (-> self.currentSlideElement.animate animateStyle, self.settings.speed * 2, self.raiseAnimationFinished), self.settings.speed * 2

  flashHorizontalSlideIn = (initialLeft) ->
    beforeAnimation =
      top: (if @settings.alignBottom then 'auto' else '0')
      bottom: (if @settings.alignBottom then '-7px' else 'auto')
      left: initialLeft
      position: 'absolute'
      display: 'block'

    afterAnimation =
      top: 'auto'
      left: 'auto'
      position: 'relative'

    flashSlideIn.apply @ [beforeAnimation, {left: '0'}, afterAnimation]

  $.fn.ramblingSlider.defaults.imageTransitions =
    boxRandom: -> @fadeBoxes $.fn.shuffle

  $.each transitions, (index, group) ->
    $.each group, (index, transition) ->
      $.each group.suffixes, (index, suffix) ->
        $.fn.ramblingSlider.defaults.imageTransitions["#{transition.name}#{suffix.name}"] = -> @[transition.helper] suffix.sorter

  for name, value of animationFullImageOptions then do (name, value) ->
    $.fn.ramblingSlider.defaults.imageTransitions[name] = -> @animateFullImage value

  $.fn.ramblingSlider.defaults.imageFlashTransitions =
    fadeOut: ->
      self = @
      slice = self.getOneSlice self.previousSlideElement
      slice.css height: '100%', width: slice.parents('.ramblingSlider').width(), position: 'absolute', top: 0, left: 0, opacity: '1'

      self.setSliderBackground()
      slice.animate {opacity: '0'}, self.settings.speed * 2, '', ->
        slice.css display: 'none'
        self.raiseAnimationFinished()

  $.fn.ramblingSlider.defaults.flashTransitions =
    slideInRight: ->
      slider = @currentSlideElement.parents('.ramblingSlider').first()
      flashHorizontalSlideIn.apply @, [-slider.width()]
    slideInLeft: ->
      slider = @currentSlideElement.parents('.ramblingSlider').first()
      flashHorizontalSlideIn.apply @ [slider.width()]

  $.extend $.fn.ramblingSlider.defaults.imageFlashTransitions, $.fn.ramblingSlider.defaults.flashTransitions

  $.fn.ramblingSlider.defaults.transitionGroups = ['fade', 'rollover', 'slideIn']
  $.each transitions, (index, group) ->
    $.each group, (index, element) ->
      $.fn.ramblingSlider.defaults.transitionGroups.push element.name

  $.fn.ramblingSlider.defaults.transitionGroupSuffixes = ['Right', 'Left', 'OutIn', 'InOut', 'Random', 'Reverse', 'In', 'Out']
)(jQuery)
