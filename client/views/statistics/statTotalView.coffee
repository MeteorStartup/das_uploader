Router.route 'statTotalView'

Template.statTotalView.onRendered ->
  $('#date01').datepicker({dateFormat: 'yy-mm-dd'})
  $('#date02').datepicker({dateFormat: 'yy-mm-dd'})
#    appendText: '(yy-mm-dd)'
#    dateFormat: 'yy-mm-dd'
#    altField: '#datepicker-4'
#    altFormat: 'DD, d MM, yy'
