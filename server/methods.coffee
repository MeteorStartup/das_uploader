Meteor.methods
  'getAgentSetting': (AGENT_URL) ->
    cl 'getAgentSetting'
    agent = CollectionAgents.findOne('AGENT_URL': AGENT_URL)
    return agent

  'insertDAS': (strDasInfo) ->
#_.extend 해서 서비스명 필드를 추가해서 넣어줘야함.
    dasInfo = dataSchema 'DASInfo'
    arrDasInfo =  strDasInfo.split '\n'
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

    dasInfo.SERVICE_NAME = CollectionServices.findOne(SERVICE_ID: dasInfo.SERVICE_ID).SERVICE_NAME or ''

    cl dasInfo
    CollectionDasInfos.insert dasInfo

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