@cl = (msg) ->
  console.log msg

@Date.prototype.addSeconds = (s) ->
  @setSeconds @getSeconds() + s
  return @
@Date.prototype.addMinutes = (m) ->
  @setMinutes @getMinutes() + m
  return @
@Date.prototype.addHours = (h) ->
  @setHours @getHours() + h
  return @
@Date.prototype.addDates = (d) ->
  @setDate @getDate() + d
  return @
@Date.prototype.clone = -> return new Date @getTime()

@jUtils =
  formatBytes: (bytes, decimals) ->
#    usage: formatBytes(139328839)
    if(bytes == 0) then return '0 Byte'
    k = 1000
    dm = decimals + 1 || 3
    sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB']
    i = Math.floor(Math.log(bytes) / Math.log(k))
    return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i]
  getStringYMDFromDate: (_date) ->
    return moment(_date).format(jDefine.timeFormatYMD)
  getStringMDHMFromDate: (_date) ->
    return moment(_date).format(jDefine.timeFormatMDHM)
  getStringMDFromDate: (_date) ->
    return moment(_date).format(jDefine.timeFormatMD)
  getStringHMSFromDate: (_date) ->
    return moment(_date).format(jDefine.timeFormatHMS)
  getStringHFromDate: (_date) ->
    return moment(_date).format(jDefine.timeFormatH)
  getStringMFromDate: (_date) ->
    return moment(_date).format(jDefine.timeFormatM)
  getStringHMFromDate: (_date) ->
    return moment(_date).format(jDefine.timeFormatHM)
  getStringYMDHMSFromDate: (_date) ->
    return moment(_date).format(jDefine.timeFormat)
  getDateFromString: (_date) ->
    return moment(_date, jDefine.timeFormat).toDate()

