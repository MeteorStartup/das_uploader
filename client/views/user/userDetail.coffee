userRv = new ReactiveVar()
Router.route 'userDetail',
  path: '/userDetail/:_id'

Template.userDetail.onCreated ->
  Meteor.call 'getUserInfoById', Router.current().params._id, (err, rslt) ->
    if err then alert err
    else
      cl rslt
      userRv.set rslt

Template.userDetail.helpers
  userInfo: -> userRv?.get()

Template.userDetail.events
  'click [name=btnEdit]': (e, tmpl) ->
    e.preventDefault()
    alert '수정기능은 준비중입니다'
    return false

  'click [name=btnDelete]': (e, tmpl) ->
    e.preventDefault()
    if confirm '삭제하시겠습니까?'
      Meteor.call 'removeUserById', Router.current().params._id, (err, rslt) ->
        if err then alert err
        else
          alert '삭제되었습니다.'
          Router.go 'userList'
