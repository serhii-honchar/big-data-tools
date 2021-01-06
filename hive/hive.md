Hive used its default delimiters: a Ctrl-A character (Unicode 0x0001 ) between fields and a
newline at the end of each record. When we used Hive to access the contents of this table
(in a SELECT statement), Hive converted this to a tab-delimited representation for display
on the console.


hive -hiveconf hive.root.logger=DEBUG,console
