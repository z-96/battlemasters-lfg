jQuery ->
  $("[data-tooltip]").each (index, el) ->
    mouseover = (evt) ->
      left = evt.pageX + 5
      top  = evt.pageY - $(window).scrollTop() + 5
      el = $("<span>").addClass("tooltip").text($(this).data('tooltip'))
      el.css({'position': 'absolute', 'left': left, 'top': top})
      $(this).data 'tooltip-el', el
      el.appendTo('body').show()
    mouseout = ->
      $(this).data('tooltip-el').remove()
    $(el).hover mouseover, mouseout

  $("[data-rollover]").each (index, el) ->
    mouseover = ->
      $(this).data 'orig-src', $(this).attr('src')
      $(this).attr 'src', $(this).data('rollover')
    mouseout = ->
      $(this).attr 'src', $(this).data('orig-src')
    $(el).hover mouseover, mouseout