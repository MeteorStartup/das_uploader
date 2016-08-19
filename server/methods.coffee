Meteor.startup ->
  Meteor.methods
    'getAgentSetting': (AGENT_URL) ->
      cl 'getAgentSetting'
      try
        agent = CollectionAgents.findOne('AGENT_URL': AGENT_URL)
      catch e
        return throw new Meteor.Error 'agent not found'
      return agent

    'insertDAS': (strDasInfo, agentUrl) ->
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
      try
        service = CollectionServices.findOne(SERVICE_ID: dasInfo.SERVICE_ID)
        agent = CollectionAgents.findOne(AGENT_URL: agentUrl)
        dasInfo.SERVICE_NAME = service.SERVICE_NAME or ''
        dasInfo.AGENT_NAME = agent.AGENT_NAME or ''
        dasInfo.AGENT_URL = agent.AGENT_URL
        dasInfo.AGENT_URL_FROM_AGENT = agentUrl
        dasInfo.KEEP_PERIOD = Math.round(Math.abs((dasInfo.DEL_DATE.getTime() - dasInfo.REQ_DATE.getTime())/(24*60*60*1000)))
      catch e
#        에러 발생 시 status를 미리 결정 짓고 더 이상 처리 하지 않는다
        cl msg = '#### Service or Agent not found ####'
        dasInfo.STATUS = "#{msg}: #{e.message}"

      CollectionDasInfos.insert dasInfo

#     용량 통계 추가
      sizeInfo = CollectionSizeInfos.findOne SERVICE_ID: dasInfo.SERVICE_ID
      if sizeInfo?
        cl sizeInfo.업로드용량 += dasInfo.UP_FSIZE
        CollectionSizeInfos.update _id: sizeInfo._id, sizeInfo
      else
        sizeStatus = dataSchema '용량통계'
        sizeStatus.SERVICE_ID = dasInfo.SERVICE_ID
        sizeStatus.업로드용량 = dasInfo.UP_FSIZE
        CollectionSizeInfos.insert sizeStatus

