cl = console.log
fiber = require 'fibers'
#  admin 등 기본 셋팅이 들어가야 한다

Meteor.startup ->

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


#  run checking process
  runDMS = ->
    now = new Date();
    mils = new Date(now.getFullYear(), now.getMonth(), now.getDate(), now.getHours(), now.getMinutes(), now.getSeconds()+3, 0) - now
    if (mils < 0)
      mils += 1000*60*60*24
    setTimeout ->
      runDMS()
      fiber ->
        CollectionDasInfos.find(STATUS: 'wait').forEach (dasInfo) ->


      .run()
    , mils

  runDMS()

##      dasInfo Test Script      ###
#  date = new Date()
#  date = date.addDates(-100)
#
#  for i in [0...10000]
#    rand = Math.random()
#    obj =
#      "AGENT_NAME" : "dasAgent#{do -> if rand < 0.3 then 1 else if rand < 0.5 then 2 else 3}"
#      "AGENT_URL" : "http://localhost:#{do -> if rand < 0.3 then 3000 else if rand < 0.5 then 3100 else 3200}"
#      "SERVICE_ID" : "SVC0000#{do -> if i > 5000 then 2 else 1}"
#      "SERVICE_NAME" : "das서비스#{do -> if i > 5000 then 2 else 1}"
#      "BOARD_ID" : "BRD#{do -> if rand < 0.3 then '00001' else if rand < 0.5 then '00002' else '00003'}"
#      "CUR_IP" : "10.0.0.24"
#      "DEL_FILE_LIST" : [
#        "/data/images/#{i}.jpg"
#        " /data/files/#{i*2}.doc"
#      ]
#      "DEL_DB_URL" : "http://10.0.0.24/delBoard.do?b_id=I38fPie98Kjf"
#      "DEL_DB_QRT" : ""
#      "UP_FSIZE" : (Math.random() * 1000000) + 1
#      "AGENT_URL_FROM_AGENT" : "http://localhost:3000"
#    obj.createdAt = date.addMinutes(Math.round (rand*30)+1)
#    obj.REQ_DATE = date.clone()
#    obj.DEL_DATE = date.clone().addDates Math.round (rand*100)+1
#    obj.KEEP_PERIOD = Math.round(Math.abs((obj.DEL_DATE.getTime() - obj.REQ_DATE.getTime())/(24*60*60*1000)));
#    obj.STATUS = do ->
#      if rand < 0.1 then 'error test'
#      else if rand > 0.5 then 'wait'
#      else 'success'
#    CollectionDasInfos.insert obj
#
#
