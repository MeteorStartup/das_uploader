servicesRv = new ReactiveVar()
Router.route 'history'

Template.history.onCreated ->
  Meteor.call 'getServiceLists', (err, rslt) ->
    if err then alert err
    else
      servicesRv.set rslt

Template.history.onRendered ->


Template.history.helpers
  services: -> servicesRv?.get()

Template.history.events