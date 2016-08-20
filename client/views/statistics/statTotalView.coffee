servicesRv = new ReactiveVar()  #select용 서비스
searchFlag = new ReactiveVar()  #버튼중복클릭금지 flag
lineStatDatas = new ReactiveVar() #꺽은선그래프 datas
pieStatDatas = new ReactiveVar()  #기간별 pieGraph datas
delPerErrDatas = new ReactiveVar()  #처리대오류 Graph datas
tabId = new ReactiveVar() #꺽은선그래프 탭명

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

  @autorun ->
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
        dataLabels:
          enabled: false
#        showInLegend: true
      series: [ {
        name: 'Brands'
        colorByPoint: true
        data: do -> if pieStatDatas.get()? then libClient.calForPercent pieStatDatas.get()
      } ]
      credits:
        enabled: false
  @autorun ->
    # Build the chart
    $('#pie-chart-2').highcharts
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
        dataLabels:
          enabled: false
#        showInLegend: true
      series: [ {
        name: 'Brands'
        colorByPoint: true
        data: do -> if delPerErrDatas.get()? then libClient.calForPercent delPerErrDatas.get()
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
  periodStats: ->
    if pieStatDatas.get()?
      pieStatDatas.get()
  delPerErrStats: ->
    if delPerErrDatas.get()?
      delPerErrDatas.get()
  합계: ->
    if pieStatDatas.get()?
      total = 0
      pieStatDatas.get().forEach (obj) ->
        total += obj.y
      return total
    else return 0


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
    startDay = $('#date01').val()
    endDay = $('#date01').val()
    serviceId = $('[name=selectedService]').val()
    unless searchFlag.get()
      searchFlag.set true
      Meteor.call 'getRealTimeStats', startDay, serviceId, (err, rslt) ->
        if err
          alert err
          searchFlag.set false
        else
          lineStatDatas.set rslt
          searchFlag.set false
      Meteor.call 'getPeriodStats', startDay, endDay, serviceId, (err, rslt) ->
        if err
          alert err
        else
          pieStatDatas.set rslt
      Meteor.call 'getDelPerErrStats', startDay, endDay, serviceId, (err, rslt) ->
        if err
          alert err
        else
          delPerErrDatas.set rslt

    else
      alert '통계데이터 생성중입니다. 잠시만 기다려주세요.'