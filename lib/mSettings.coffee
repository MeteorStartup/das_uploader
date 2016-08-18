#both
@mSettings =
  isTest: true

if Meteor.isServer
  _.extend mSettings,
    serverSEtting: 'serverValue'


if Meteor.isClient
  _.extend mSettings,
    clientSetting: 'clientValue'