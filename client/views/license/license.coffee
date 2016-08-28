licenseRv = new ReactiveVar()

Router.route 'license'

Template.license.onCreated ->
  Meteor.call 'getLicenceInfo', (err, rslt) ->
    if err then alert err
    else
      licenseRv.set rslt

Template.license.helpers
  licenseInfo: -> licenseRv.get()

Template.license.events
  'click .btn_serial': (e, tmpl) ->
    $('.modal').removeClass('hide')
  'click .btn_close': (e, tmpl) ->
    $('#serialInp').val('')
    $('.modal').addClass('hide')
  'click .btn_serial_check': (e, tmpl) ->
    Meteor.call 'saveSerialNo', $('#serialInp').val(), (err, rslt) ->
      if err then alert err
      else
        $('.modal').addClass('hide')
        $('#serialInp').val('')
        Meteor.call 'getLicenceInfo', (err, rslt) ->
          if err then alert err
          else
            licenseRv.set rslt
        alert '라이선스가 갱신되었습니다.'
