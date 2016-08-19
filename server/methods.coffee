Meteor.methods
  'insertAgentInfo': (_agent) ->
    CollectionAgents.insert _agent

  updateAgentInfo: (_id, _agent) ->
    CollectionAgents.update _id: _id, _agent

  'getAgentLists': ->
    CollectionAgents.find({},{sort:'Agent명':1}).fetch()

  removeAgent: (_id) ->
    CollectionAgents.remove _id: _id

  getAgentInfoById: (_id) ->
    CollectionAgents.findOne _id: _id