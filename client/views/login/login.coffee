Router.route 'login'

Template.login.onRendered ->

Template.login.events
  'click [name=btn_login]': (e, tmpl) ->
    e.preventDefault()
    Meteor.loginWithPassword $('#MGR_ID').val(), $('#PSWD').val(), (err, rslt) ->
      if err then alert err
      else
        alert '로그인되었습니다.'
        Router.go '/'

  'keyup #PSWD': (e, tmpl) ->
    if e.which is 13
      $('[name=btn_login]').trigger('click');
