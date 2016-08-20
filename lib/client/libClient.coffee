@libClient =
  getRealtimeDate: ->
    today = $.datepicker.formatDate('yy-mm-dd', new Date());
    return {
      start: today
      end: today
    }

#  result = [
#    {
#      cate: ''
#      up: ''
#      del: ''
#      err: ''
#    }
#    ...
#  ]
  getTableTotalStats: (_data) ->
#    cl _data
    result = []
    _data.categories.forEach (cate, idx) ->
      tempObj = {}
      tempObj['cate'] = cate
      serviceCnt = _data.seriesUp.length
      tempObj['up'] = 0
      tempObj['del'] = 0
      tempObj['err'] = 0
      for i in [0...serviceCnt]
#        cl i
        tempObj['up'] += _data.seriesUp[i].data[idx]
        tempObj['del'] += _data.seriesDel[i].data[idx]
        tempObj['err'] += _data.seriesErr[i].data[idx]
#      cl tempObj
      result.push tempObj
#    cl result
    return result
