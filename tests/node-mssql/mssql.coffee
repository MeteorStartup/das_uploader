cl = console.log
mssql = require 'mssql'

mssql.connect('mssql://samUser:!@#User@152.99.147.11:1433/samcheok_2009').then ->
  new mssql.Request().query('select count(*) from DUAL').then (recordset) ->
    cl 'recordset'
    cl recordset
    mssql.close()
  .catch (err) ->
    cl 'err'
    cl err.toString()
    mssql.close()
.catch (err) ->
  cl err.toString()
  mssql.close()



