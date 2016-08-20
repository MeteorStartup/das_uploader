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

#로드되는 시점에 agent가 내려가 있다면 접속을 계속 시도하느라 uploader의 로드가 중단 되기 때문에
#async하게 돌려놓고 우선 서버를 구동
#근데 startup인데 왜 methods도 로드가 안된상황에서 실행이 되지?
  setInterval ->
    fibers ->
      runDMS()
    .run()
  , 1000 * 60


  runDMS = ->
    CollectionDasInfos.find(STATUS: 'wait').forEach (dasInfo) ->
#      delete files
      dasInfo.STATUS = 'success'    #순차적으로 모두 통과해야만 success
      service = CollectionServices.findOne SERVICE_ID: dasInfo.SERVICE_ID
      agents = CollectionAgents.find _id: $in: service.AGENT정보
      agents.forEach (agent) ->
        if agent.파일삭제기능
          try
            fut = new future()
            HTTP.post "#{agent.AGENT_URL}/removeFiles",
              data:
                DEL_FILE_LIST: dasInfo.DEL_FILE_LIST
            , (err, rslt) ->
              if err
                cl dasInfo.STATUS = err.toString()
                fibers ->
                  CollectionError.insert
                    createdAt: new Date()
                    err: err
                .run()
              fut.return()
            fut.wait()

          catch err
            cl dasInfo.STATUS = err.toString()
            fibers ->
              CollectionError.insert
                createdAt: new Date()
                err: err
            .run()
#      delete query
      try
        mysqlDB = mysql.createConnection
          host: 'localhost'
          user: 'root'
          password: 'Thflskf0'
          database: 'test'
        mysqlDB.connect()
        arr_queries = dasInfo.DEL_DB_QRY.split(';')
        arr_queries = arr_queries.filter (str) -> if str.length > 0 then true else false
#        arr_queries = [
#          'SET @num = (SELECT count(*) from TEST_TABLE);delete from TEST_TABLE WHERE idTest_TABLE=@num'
#          'delete from TEST_TABLE WHERE idTest_TABLE=@num'
#        ]
        arr_queries.forEach (query) ->
          mysqlDB.query query, (err, rows, fields) ->
            if err
              cl 'delete mysql db'
              cl dasInfo.STATUS = err.toString()
              fibers ->
                CollectionError.insert
                  createdAt: new Date()
                  err: err
              .run()
        mysqlDB.end()

      catch err
        cl dasInfo.STATUS = err.toString()
        fibers ->
          CollectionError.insert
            createdAt: new Date()
            err: err
        .run()

##      delete url
#      if dasInfo.DEL_DB_URL? and dasInfo.DEL_DB_URL.length > 0
#        fut = new future()
#        HTTP.get dasInfo.DEL_DB_URL, (err, rslt) ->
#          if err
##            이녀석은 async다. 나중에 처리하자.
##            timeout 이 너무 길어져서 다 기다릴 수가 없다
#            cl 'delete url'
#            cl dasInfo.STATUS = err.toString()
##            fibers ->
##              CollectionError.insert err
##            .run()
##          fut.return()
##        fut.wait()

      #      최종 dasInfo update
      CollectionDasInfos.update _id: dasInfo._id, dasInfo





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
