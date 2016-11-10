cl = console.log
mysql = require 'mysql'
future = require 'fibers/future'

mysqlDB = mysql.createConnection
  host: '152.99.148.50'
  port: '3306'
  user: 'hongcheon'
  password: 'poigksshin!23'
  database: 'HONGCHEON'
fut = new future()
mysqlDB.connect (err) ->
  fut.return err?.message or 'success'
mysqlDB.query 'select * from TEST_TABLE;', (err, rows, fields) ->
  cl err or rows
mysqlDB.end()
return fut.wait()

