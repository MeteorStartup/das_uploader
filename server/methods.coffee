Meteor.startup ->
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
