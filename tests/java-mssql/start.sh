#!/bin/sh
javac MsSQL.java
java MsSQL "jdbc:sqlserver://52.78.177.44;user=sa;password=mStartup!24;database=dasuploader" "select * from dasuploader.dasuploader"