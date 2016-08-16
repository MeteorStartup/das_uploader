Template.sideMenus.events
  'mouseenter .menu_list > li': (e, tmpl) ->
    $('.menu_list > li').removeClass 'on'
    $(e.target).addClass 'on'
  'mouseenter .menu_list': (e, tmpl) ->
    $(e.target).attr('style', 'width: 260px')
  'mouseleave .menu_list': (e, tmpl) ->
    $(e.target).attr('style', 'width: 70px')
    $('.menu_list > li').removeClass 'on'
