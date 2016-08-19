Meteor.startup ->
  cl 'methods'
  HTTP.methods
    'getAgentSetting': (data) ->
      cl 'getAgentSetting'
      try
        agent = CollectionAgents.findOne('AGENT_URL': data.AGENT_URL)
      catch e
        return throw new Meteor.Error 'agent not found'
      return agent
    'insertDAS': (data) ->
      dasInfo = dataSchema 'DASInfo'
      arrDasInfo =  data.dasInfo.split '\n'
      arrDasInfo.forEach (line) ->
#      add field to object
        pos = line.indexOf '='
        key = line.substring 0, pos
        val = line.substring pos + 1

        switch key
          when 'UP_FSIZE'
            val = val-0
          when 'REQ_DATE', 'DEL_DATE'
            year = val.substring(0,4)
            month = val.substring(4,6) - 1
            date = val.substring(6,8)
            hour = val.substring(8,10)
            minute = val.substring(10,12)
            second = val.substring(12,14)
            mil = val.substring(14,17)

            val = new Date(year, month, date, hour, minute, second, mil)
          when 'DEL_FILE_LIST'
            val = val.split(',')

        if key isnt '' and val isnt ''
          dasInfo[key] = val
      try
        service = CollectionServices.findOne(SERVICE_ID: dasInfo.SERVICE_ID)
        agent = CollectionAgents.findOne(AGENT_URL: data.AGENT_URL)
        dasInfo.SERVICE_NAME = service.SERVICE_NAME or ''
        dasInfo.AGENT_NAME = agent.AGENT_NAME or ''
        dasInfo.AGENT_URL = agent.AGENT_URL
        dasInfo.AGENT_URL_FROM_AGENT = data.AGENT_URL
        dasInfo.KEEP_PERIOD = Math.round(Math.abs((dasInfo.DEL_DATE.getTime() - dasInfo.REQ_DATE.getTime())/(24*60*60*1000)))
      catch e
#        서비스/에이전트 확인 에러 발생 시 status를 미리 결정 짓고 더 이상 처리 하지 않는다
        cl msg = '#### Service or Agent not found ####'
        dasInfo.STATUS = "#{msg}: #{e.message}"

      CollectionDasInfos.insert dasInfo

      #     용량 통계 추가
      sizeInfo = CollectionSizeInfos.findOne SERVICE_ID: dasInfo.SERVICE_ID
      if sizeInfo?
        sizeInfo.업로드용량 += dasInfo.UP_FSIZE
        CollectionSizeInfos.update _id: sizeInfo._id, sizeInfo
      else
        sizeStatus = dataSchema '용량통계'
        sizeStatus.SERVICE_ID = dasInfo.SERVICE_ID
        sizeStatus.업로드용량 = dasInfo.UP_FSIZE
        CollectionSizeInfos.insert sizeStatus
      return 'success'




#  Meteor.methods
#    'getAgentSetting': (AGENT_URL) ->
#      cl 'getAgentSetting'
#      try
#        agent = CollectionAgents.findOne('AGENT_URL': AGENT_URL)
#      catch e
#        return throw new Meteor.Error 'agent not found'
#      return agent
#
#    'insertDAS': (strDasInfo, agentUrl) ->
#      dasInfo = dataSchema 'DASInfo'
#      arrDasInfo =  strDasInfo.split '\n'
#      arrDasInfo.forEach (line) ->
#  #      add field to object
#        pos = line.indexOf '='
#        key = line.substring 0, pos
#        val = line.substring pos + 1
#
#        switch key
#          when 'UP_FSIZE'
#            val = val-0
#          when 'REQ_DATE', 'DEL_DATE'
#            year = val.substring(0,4)
#            month = val.substring(4,6) - 1
#            date = val.substring(6,8)
#            hour = val.substring(8,10)
#            minute = val.substring(10,12)
#            second = val.substring(12,14)
#            mil = val.substring(14,17)
#
#            val = new Date(year, month, date, hour, minute, second, mil)
#          when 'DEL_FILE_LIST'
#            val = val.split(',')
#
#        if key isnt '' and val isnt ''
#          dasInfo[key] = val
#      try
#        service = CollectionServices.findOne(SERVICE_ID: dasInfo.SERVICE_ID)
#        agent = CollectionAgents.findOne(AGENT_URL: agentUrl)
#        dasInfo.SERVICE_NAME = service.SERVICE_NAME or ''
#        dasInfo.AGENT_NAME = agent.AGENT_NAME or ''
#        dasInfo.AGENT_URL = agent.AGENT_URL
#        dasInfo.AGENT_URL_FROM_AGENT = agentUrl
#        dasInfo.KEEP_PERIOD = Math.round(Math.abs((dasInfo.DEL_DATE.getTime() - dasInfo.REQ_DATE.getTime())/(24*60*60*1000)))
#      catch e
##        서비스/에이전트 확인 에러 발생 시 status를 미리 결정 짓고 더 이상 처리 하지 않는다
#        cl msg = '#### Service or Agent not found ####'
#        dasInfo.STATUS = "#{msg}: #{e.message}"
#
#      CollectionDasInfos.insert dasInfo
#
##     용량 통계 추가
#      sizeInfo = CollectionSizeInfos.findOne SERVICE_ID: dasInfo.SERVICE_ID
#      if sizeInfo?
#        sizeInfo.업로드용량 += dasInfo.UP_FSIZE
#        CollectionSizeInfos.update _id: sizeInfo._id, sizeInfo
#      else
#        sizeStatus = dataSchema '용량통계'
#        sizeStatus.SERVICE_ID = dasInfo.SERVICE_ID
#        sizeStatus.업로드용량 = dasInfo.UP_FSIZE
#        CollectionSizeInfos.insert sizeStatus
#      return 'success'
#

Meteor.methods
  'insertAgentInfo': (_agent) ->
    CollectionAgents.insert _agent

  updateAgentInfo: (_id, _agent) ->
    CollectionAgents.update _id: _id, _agent

  'getAgentLists': ->
    CollectionAgents.find({},{sort:'AGENT_NAME':1}).fetch()

  removeAgent: (_id) ->
    CollectionAgents.remove _id: _id

  getAgentInfoById: (_id) ->
    CollectionAgents.findOne _id: _id

  insertServiceInfo: (_service) ->
    CollectionServices.insert _service

  updateServiceInfo: (_id, _service) ->
    CollectionServices.update _id: _id, _service

  getServiceInfoById: (_id) ->
    CollectionServices.findOne _id: _id

  getServiceLists: ->
    CollectionServices.find({},{sort:'SERVICE_NAME':1}).fetch()

  getUserLists: (condition) ->
    cl condition
    if condition.search? and condition.search.length >0
      _.extend condition.where,
        $or: [
          {'username': new RegExp condition.search, 'i'}
          ,{'profile.이름': new RegExp condition.search, 'i'}
        ]

    Meteor.users.find(condition.where, condition.options).fetch()


  addUser: (obj) ->
    options = {}
    options.username = obj.아이디
    options.email = obj.이메일 or ''
    options.password = obj.비밀번호
    options.profile = dataSchema 'profile',
      이름: obj.이름
      이메일: obj.이메일
      휴대폰: obj.휴대폰
      사용권한: obj.사용권한
      상태: obj.상태
    rslt = Accounts.createUser options
    unless rslt then return throw new Meteor.Error '사용자 생성 실패'
    else return '사용자 생성 완료'

  idDuplCheck: (id) ->
    count = Meteor.users.find(username: id).count()
    if count > 0
      throw new Meteor.Error '이미 사용중인 아이디입니다.'
    else
      return '사용가능합니다.'

  getUserInfoById: (_id) ->
#    cl _id
    Meteor.users.findOne({_id: _id}, {
      fields:
        username: 1
        profile: 1
    })

  removeUserById: (_id) ->
    Meteor.users.remove _id: _id