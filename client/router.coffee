Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'

Router.route '/',
  template: 'home'

Router.onBeforeAction ->
  $(window).scrollTop 0
  @next()

Router.onBeforeAction ->
  unless Meteor.loggingIn()
    if Meteor.userId()?
      Router.go '/'
    else @next()
  else @next()
,
  only: ['login']

Router.onBeforeAction ->
  # todo Meteor.userId()는 나오는데 Meteor.user()는 안나온다 (Meteor.users.find() 마찬가지)
  # 일단은 userId()로 선 체크 하도록하고 향후 업데이트에 따라서 Meteor.user()를 바로 사용하던지 하자.
  unless Meteor.loggingIn()
    unless Meteor.userId()
      Router.go 'login' # tip : loginScreen 교체시 except 에도 추가해야 접근이 가능함.
    else @next()
  else @next()
,
  except: ['login']
