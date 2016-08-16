Template.home.events
  'click #agent_content > li': (e, tmpl) ->
#    show = $(e.target).children('a')
#    sub = $(e.target).children('ul')
#    cl show
#    cl sub
#    if show.hasClass('plus')
#      cl 'a'
#      show.removeClass 'plus'
#      show.addClass 'minus'
#      sub.addClass 'show'
#    else
#      cl 'b'
#      show.removeClass 'minus'
#      show.addClass 'plus'
#      sub.removeClass 'show'

  'click .tab > ul': (e, tmpl) ->
    target = $(e.target).parent()
    $('.tab > ul > li').removeClass 'on'
    target.addClass 'on'