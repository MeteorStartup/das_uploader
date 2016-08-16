Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'

Router.route '/',
  template: 'home'

Router.onBeforeAction ->
  $(window).scrollTop 0
  @next()