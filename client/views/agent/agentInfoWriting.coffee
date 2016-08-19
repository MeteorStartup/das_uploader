agent = new ReactiveVar()

Router.route 'agentInfoWriting'
Router.route 'agentInfoEditing',
  path: '/agentInfoEditing/:_id'
  template: 'agentInfoWriting'

Template.agentInfoWriting.onCreated ->
  if Router.current().route.getName() is 'agentInfoEditing'
    Meteor.call 'getAgentInfoById', Router.current().params._id, (err, rslt) ->
      if err then alert err
      else
        cl rslt
        agent.set rslt


Template.agentInfoWriting.helpers
  agent: ->
    if agent? then agent.get()
    else []

Template.agentInfoWriting.events
  'click [name=btnSave]': (e, tmpl) ->
    Agent명 = $('[name=Agent명]').val()
    Agent_URL = $('[name=Agent_URL]').val()
    소멸정보절대경로 = $('[name=소멸정보절대경로]').val()
    소멸정보전송기능 = $('[name=소멸정보전송기능]').is(':checked')
    파일삭제기능 = $('[name=파일삭제기능]').is(':checked')

    obj = dataSchema 'Agent정보',
      Agent명: Agent명
      Agent_URL: Agent_URL
      소멸정보절대경로: 소멸정보절대경로
      소멸정보전송기능: 소멸정보전송기능
      파일삭제기능: 파일삭제기능

    cl obj

    if Router.current().route.getName() is 'agentInfoWriting'
      Meteor.call 'insertAgentInfo', obj, (err, rslt) ->
        if err then alert err
        else
          alert '저장되었습니다.'
          Router.go 'agentInfoFind'
    else
      Meteor.call 'updateAgentInfo', Router.current().params._id, obj, (err, rslt) ->
        if err then alert err
        else
          alert '저장되었습니다.'
          Router.go 'agentInfoFind'

