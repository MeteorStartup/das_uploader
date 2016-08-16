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

