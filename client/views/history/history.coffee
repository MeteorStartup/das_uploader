Router.route 'history'

Template.history.onRendered ->


Template.history.events
  'click .radio': (e, tmpl) ->
    if ((target = $(e.target)).hasClass('radio')) or ((target = $(e.target).parent()).hasClass('radio'))
      $('.radio').removeClass 'radio_on'
      target.addClass 'radio_on'