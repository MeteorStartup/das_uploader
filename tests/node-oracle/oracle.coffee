oracle = require('oracle')
connectData =
  hostname: '152.99.176.114'
  port: 15997
  database: 'ORAGS'
  user: 'oracle'
  password: 'oracle'
oracle.connect connectData, (err, connection) ->
  if err
    console.log 'Error connecting to db:', err
    return
  connection.execute 'SELECT systimestamp FROM dual', [], (err, results) ->
    if err
      console.log 'Error executing query:', err
      return
    console.log results
    connection.close()
    # call only when query is finished executing
    return
  return