future = require 'fibers/future'
fibers = require 'fibers'
mysql = require 'mysql'
Meteor.startup ->

#로드되는 시점에 agent가 내려가 있다면 접속을 계속 시도하느라 uploader의 로드가 중단 되기 때문에
#async하게 돌려놓고 우선 서버를 구동
#근데 startup인데 왜 methods도 로드가 안된상황에서 실행이 되지?
  setInterval ->
    fibers ->
      runDMS()
    .run()
  , 1000 * 60 * 60


  @runDMS = ->
    cl 'runDMS'
    CollectionDasInfos.find(STATUS: 'wait').forEach (dasInfo) ->
      service = CollectionServices.findOne SERVICE_ID: dasInfo.SERVICE_ID
      unless service
        dasInfo.STATUS = 'service not found'
        return CollectionDasInfos.update _id: dasInfo._id, dasInfo

      if service.상태 is false then return  #해당 서비스의 처리 않함 상태

      agents = CollectionAgents.find _id: $in: service.AGENT정보
      if agents.count() is 0
        dasInfo.STATUS = 'agent not found'
        return CollectionDasInfos.update _id: dasInfo._id, dasInfo

      ## delete files
      dasInfo.STATUS = 'success'    #순차적으로 모두 통과해야만 success

      if dasInfo.STATUS is 'success'
        agents.forEach (agent) ->
          if agent.파일삭제기능
            try
              fut = new future()
              HTTP.post "#{agent.AGENT_URL}/removeFiles",
                data:
                  DEL_FILE_LIST: dasInfo.DEL_FILE_LIST
                  DEL_OPTION: service.파일처리옵션
              , (err, rslt) ->
                if err
                  cl err.toString()
                  cl dasInfo.STATUS = err.toString()
#                  Error: connect ECONNREFUSED is the key for agent conn error
                  dasInfo.STATUS = err
#                else
#                  fibers ->
#                    dasInfo.STATUS = 'success'
#                    CollectionDasInfos.update _id: dasInfo._id, dasInfo
#                  .run()
                else
                  unless rslt.content is 'success' then dasInfo.STATUS = rslt
                fut.return()
              fut.wait()

            catch err
              cl dasInfo.STATUS = err.toString()
              dasInfo.STATUS = err
##      delete query
      if dasInfo.STATUS is 'success'
        try
          mysqlDB = mysql.createConnection service.DB정보.DB접속URL
#            host: 'localhost'
#            user: 'root'
#            password: 'Thflskf0'
#            database: 'test'
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
                dasInfo.STATUS = err
          mysqlDB.end()

        catch err
          cl 'here'
          cl err
          cl dasInfo.STATUS = err.toString()
          dasInfo.STATUS = err

##      delete url
#      if dasInfo.STATUS is 'success'
#        if dasInfo.DEL_DB_URL? and dasInfo.DEL_DB_URL.length > 0
#          fut = new future()
#          HTTP.get dasInfo.DEL_DB_URL, (err, rslt) ->
#            if err
#  #            이녀석은 async다. 나중에 처리하자.
#  #            timeout 이 너무 길어져서 다 기다릴 수가 없다
#              cl 'delete url'
#              cl dasInfo.STATUS = err.toString()
#  #            fibers ->
#  #              CollectionError.insert err
#  #            .run()
#  #          fut.return()
#  #        fut.wait()

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
