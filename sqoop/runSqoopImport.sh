#Importing to HDFS
#FAILED
#sqoop import \
#    --connect jdbc:mysql://procamp-cluster-m:13306/information_schema \
#    --table CHARACTER_SETS \
#    --username userdev1 \
#    --password password4dev1 \
#    --target-dir /usr/serg/sqoop/test/chars
#
##if primary key is not specified use -m 1 or --split-by option
#
#FAILED
#sqoop import \
#    --connect jdbc:mysql://127.0.0.1:13306/information_schema \
#    --table CHARACTER_SETS \
#    --username userdev1 \
#    --password password4dev1 \
#    --split-by 'MAXLEN'\
#     --target-dir /usr/serg/sqoop/test/chars
#
## some host should be specified to run job in cluster
sqoop import \
    --connect jdbc:mysql://procamp-cluster-m:13306/information_schema \
    --table CHARACTER_SETS \
    --username userdev1 \
    --password password4dev1 \
    --split-by 'MAXLEN'\
     --target-dir /usr/serg/sqoop/test/chars



#Importing to Hive
sqoop import \
    --hive-import \
    --connect jdbc:mysql://procamp-cluster-m:13306/information_schema \
    --table CHARACTER_SETS \
    --username userdev1 \
    --password password4dev1 \
    --fields-terminated-by ',' \
    --create-hive-table \
    --split-by 'MAXLEN'\
    --hive-table default.CHARACTER_SETS