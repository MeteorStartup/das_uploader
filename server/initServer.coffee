cl = console.log
fiber = require 'fibers'

#  admin 등 기본 셋팅이 들어가야 한다

Meteor.startup ->
  HTTP.call 'POST', 'http://localhost:3000/test', merong: 'haha', (err, rslt) ->
    cl err or rslt.content




  #  reset 시 테스트 환경을 위한 데이터
  unless CollectionServices.findOne()
    agent = dataSchema 'Agent'
    agent.AGENT_NAME = 'dasAgent'
    agent.AGENT_URL = 'http://localhost:3000'
    agent.소멸정보절대경로 = '/Users/jwjin/data'
    agent_id = CollectionAgents.insert agent

    svcInfo = dataSchema 'Service'
    svcInfo.SERVICE_ID = 'SVC00001'
    svcInfo.SERVICE_NAME = 'das서비스1'
    svcInfo.파일처리옵션 = '삭제'
    svcInfo.AGENT정보.push agent_id
    CollectionServices.insert svcInfo

    svcInfo = dataSchema 'Service'
    svcInfo.SERVICE_ID = 'SVC00002'
    svcInfo.SERVICE_NAME = 'das서비스2'
    svcInfo.파일처리옵션 = '삭제'
    svcInfo.AGENT정보.push agent_id
    CollectionServices.insert svcInfo


