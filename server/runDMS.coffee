future = require 'fibers/future'
fibers = require 'fibers'
mysql = require 'mysql'
Meteor.startup ->
  #  run checking process
#  mysqlDB = mysql.createConnection
#    host: 'localhost'
#    user: 'root'
#    password: 'Thflskf0'
#    database: 'test'
#  mysqlDB.connect()
#  queries = [
#    'SET @num = (SELECT count(*) from TEST_TABLE)'
#    'delete from TEST_TABLE WHERE idTest_TABLE=@num'
#  ]
#  queries.forEach (query) ->
#    mysqlDB.query query, (err, rows, fields) ->
#      cl err or rows
#  mysqlDB.end()


  runDMS = ->
    CollectionDasInfos.find(STATUS: 'wait').forEach (dasInfo) ->
#      delete files
      service = CollectionServices.findOne SERVICE_ID: dasInfo.SERVICE_ID
      agents = CollectionAgents.find _id: $in: service.AGENT정보
      agents.forEach (agent) ->
        if agent.파일삭제기능
          try
            ddpAgent = DDP.connect agent.AGENT_URL
            fut = new future()
            ddpAgent.call 'removeFiles', dasInfo.DEL_FILE_LIST, (err, rslt) ->
              if err
                cl dasInfo._id
                cl err.message
                dasInfo.STATUS = err.message
              else
                dasInfo.STATUS = rslt
              fut.return()
            fut.wait()
            ddpAgent.disconnect()
            CollectionDasInfos.update _id: dasInfo._id, dasInfo
          catch e
            cl e
#      delete query
      mysqlDB = mysql.createConnection
        host: 'localhost'
        user: 'root'
        password: 'Thflskf0'
        database: 'test'
      mysqlDB.connect()
      mysqlDB.end()

#      delete url
#      if dasInfo.DEL_DB_URL? and dasInfo.DEL_DB_URL.length > 0
#        HTTP.call dasInfo.DEL_DB_URL, (err, rslt) ->
#          cl err, rslt



  #로드되는 시점에 agent가 내려가 있다면 접속을 계속 시도하느라 uploader의 로드가 중단 되기 때문에
  #async하게 돌려놓고 우선 서버를 구동
  #근데 startup인데 왜 methods도 로드가 안된상황에서 실행이 되지?
#  setTimeout ->
#    fibers ->
#      runDMS()
#    .run()
#  , 1000

#  loopDMS = ->
#    now = new Date();
#    mils = new Date(now.getFullYear(), now.getMonth(), now.clone().addDates(1).getDate(), 0, 0, 0, 0) - now
#    #    mils = new Date(now.getFullYear(), now.getMonth(), now.getDate(), now.getHours(), now.getMinutes(), now.getSeconds()+3, 0) - now
#    if (mils < 0)
#      mils += 1000*60*60*24
#    setTimeout ->
#      loopDMS()
#      fiber ->
#        runDMS()
#      .run()
#    , mils
#
#  loopDMS()
#
