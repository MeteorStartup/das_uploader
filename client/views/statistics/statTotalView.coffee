servicesRv = new ReactiveVar()
searchFlag = new ReactiveVar()
lineStatDatas = new ReactiveVar()
pieStatDatas = new ReactiveVar()
tabId = new ReactiveVar()

Router.route 'statTotalView'

Template.statTotalView.onCreated ->
  tabId.set 'seriesUp'
  searchFlag.set false
  Meteor.call 'getServiceLists', (err, rslt) ->
    if err then alert err
    else
      servicesRv.set rslt

Template.statTotalView.onRendered ->
  todayObj = libClient.getRealtimeDate()
  $('#date01').datepicker({dateFormat: 'yy-mm-dd'})
  $('#date02').datepicker({dateFormat: 'yy-mm-dd'})
  $('#date01').val(todayObj.start)
  $('#date02').val(todayObj.end)
  @autorun ->
    cl 'run autorun'
#    cl lineStatDatas.get()
    $('#line-chart-1').highcharts
      title:
        text: ''
  #      x: -20
  #    subtitle:
  #      text: 'Source: WorldClimate.com'
  #      x: -20
      xAxis: categories: lineStatDatas.get()?.categories
      yAxis:
        title: text: '(건)'
        plotLines: [ {
          value: 0
          width: 1
          color: '#808080'
        } ]
      tooltip: valueSuffix: '건'
      legend:
        layout: 'vertical'
        align: 'right'
        verticalAlign: 'middle'
        borderWidth: 0
      series: do ->
        switch tabId.get()
          when 'seriesUp'
            lineStatDatas.get()?.seriesUp
          when 'seriesDel'
            lineStatDatas.get()?.seriesDel
          when 'seriesErr'
            lineStatDatas.get()?.seriesErr

      credits:
        enabled: false


    # Build the chart
    $('#pie-chart-1').highcharts
      chart:
        backgroundColor: 'transparent'
#        plotBackgroundColor: "#d2dfe9"
        plotBorderWidth: 0
        borderWidth: 0
        plotShadow: false
        type: 'pie'
#      title: text: 'Browser market shares January, 2015 to May, 2015'
      title: text: null
      tooltip: pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
      plotOptions: pie:
        allowPointSelect: true
        cursor: 'pointer'
        dataLabels: enabled: false
#        showInLegend: true
      series: [ {
        name: 'Brands'
        colorByPoint: true
        data: [
          {
            name: 'Microsoft Internet Explorer'
            y: 56.33
          }
          {
            name: 'Chrome'
            y: 24.03
            sliced: true
            selected: true
          }
          {
            name: 'Firefox'
            y: 10.38
          }
          {
            name: 'Safari'
            y: 4.77
          }
          {
            name: 'Opera'
            y: 0.91
          }
          {
            name: 'Proprietary or Undetectable'
            y: 0.2
          }
        ]
      } ]
      credits:
        enabled: false

Template.statTotalView.helpers
  services: -> servicesRv?.get()
  disabled: ->
    if searchFlag.get() then return 'disabled'
    else return ''

  statTotalInfos: ->
    if lineStatDatas.get()?
      libClient.getTableTotalStats lineStatDatas.get()
#    lineStatDatas.get()?.categories
#  categories: (index) ->
#    lineStatDatas.get()?.categories[index]
#  seriesUp: (index) ->
#    lineStatDatas.get()?.seriesUp[1].data[index]
#  seriesDel: (index) ->
#    lineStatDatas.get()?.seriesDel[1].data[index]
#  seriesErr: (index) ->
#    lineStatDatas.get()?.seriesErr[1].data[index]
Template.statTotalView.events
  'click .tab li': (e, tmpl) ->
    $('.tab li').removeClass('on')
    (target=$(e.target).parent()).addClass('on')
    tabId.set target.attr('id')

  'click .btn_box .btn_inner': (e, tmpl) ->
    if $(e.target).text() in ['일별', '주간']
      e.preventDefault()
      alert '준비중입니다.'
      return
    $('.btn_inner').removeClass('on')
    if (target=$(e.target)).hasClass('btn_inner') or (target=target.parent()).hasClass('btn_inner')
      target.addClass('on')

  'click [name=btn_search]': (e, tmpl) ->
    cl today = $('#date01').val()
    cl serviceId = $('[name=selectedService]').val()
    unless searchFlag.get()
      searchFlag.set true
      Meteor.call 'getRealTimeStats', today, serviceId, (err, rslt) ->
        if err
          alert err
          searchFlag.set false
        else
          lineStatDatas.set rslt
          searchFlag.set false
    else
      alert '통계데이터 생성중입니다. 잠시만 기다려주세요.'