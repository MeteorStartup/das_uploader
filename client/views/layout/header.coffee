Template.header.events
  'click [name=btn_logout]': (e, tmpl) ->
    e.preventDefault()
    if confirm '로그아웃 하시겠습니까?'
      Meteor.logout (err, rslt) ->
        if err then alert err
        else
          alert '로그아웃 되었습니다.'
          Router.go 'login'