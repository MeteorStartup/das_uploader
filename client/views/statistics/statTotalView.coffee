servicesRv = new ReactiveVar()

Router.route 'statTotalView'

Template.statTotalView.onCreated ->
#  cl $.datepicker.formatDate('yy-mm-dd', new Date());
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
  $('#line-chart-1').highcharts
#    title:
#      text: 'Monthly Average Temperature'
#      x: -20
#    subtitle:
#      text: 'Source: WorldClimate.com'
#      x: -20
    xAxis: categories: [
      'Jan'
      'Feb'
      'Mar'
      'Apr'
      'May'
      'Jun'
      'Jul'
      'Aug'
      'Sep'
      'Oct'
      'Nov'
      'Dec'
    ]
    yAxis:
      title: text: 'Temperature (°C)'
      plotLines: [ {
        value: 0
        width: 1
        color: '#808080'
      } ]
    tooltip: valueSuffix: '°C'
    legend:
      layout: 'vertical'
      align: 'right'
      verticalAlign: 'middle'
      borderWidth: 0
    series: [
      {
        name: 'Tokyo'
        data: [
          7.0
          6.9
          9.5
          14.5
          18.2
          21.5
          25.2
          26.5
          23.3
          18.3
          13.9
          9.6
        ]
      }
      {
        name: 'New York'
        data: [
          -0.2
          0.8
          5.7
          11.3
          17.0
          22.0
          24.8
          24.1
          20.1
          14.1
          8.6
          2.5
        ]
      }
      {
        name: 'Berlin'
        data: [
          -0.9
          0.6
          3.5
          8.4
          13.5
          17.0
          18.6
          17.9
          14.3
          9.0
          3.9
          1.0
        ]
      }
      {
        name: 'London'
        data: [
          3.9
          4.2
          5.7
          8.5
          11.9
          15.2
          17.0
          16.6
          14.2
          10.3
          6.6
          4.8
        ]
      }
    ]


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

Template.statTotalView.events
  'click .tab li': (e, tmpl) ->
    $('.tab li').removeClass('on')
    cl $(e.target).parent().addClass('on')

  'click .btn_box .btn_inner': (e, tmpl) ->
    if $(e.target).text() in ['일별', '주간']
      e.preventDefault()
      alert '준비중입니다.'
      return
    $('.btn_inner').removeClass('on')
    if (target=$(e.target)).hasClass('btn_inner') or (target=target.parent()).hasClass('btn_inner')
      target.addClass('on')
