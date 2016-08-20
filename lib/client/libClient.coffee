@libClient =
  getRealtimeDate: ->
    today = $.datepicker.formatDate('yy-mm-dd', new Date());
    return {
      start: today
      end: today
    }