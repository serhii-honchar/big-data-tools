mkdir /opt/sqoop
readonly SQOOP_BASE_DIR=/opt/sqoop
readonly PROCAMP_DIR=/opt/gl-bigdata-procamp

#download required files
wget -P ${PROCAMP_DIR} https://apache.volia.net/sqoop/1.4.7/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz
wget -P ${PROCAMP_DIR} https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.22/mysql-connector-java-8.0.22.jar
wget -P ${PROCAMP_DIR} https://apache.paket.ua/tez/0.9.2/apache-tez-0.9.2-bin.tar.gz


tar -xf ${PROCAMP_DIR}/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz -C ${SQOOP_BASE_DIR}
readonly SQOOP_BASE_DIR=/opt/sqoop
readonly PROCAMP_DIR=/opt/gl-bigdata-procamp
export SQOOP_HOME=${SQOOP_BASE_DIR}/sqoop-1.4.7.bin__hadoop-2.6.0
export PATH=$PATH:$SQOOP_HOME/bin
export HADOOP_COMMON_HOME=/usr/lib/hadoop
export HADOOP_MAPRED_HOME=/usr/lib/hadoop
export HIVE_HOME=/usr/lib/hive

#need to swith to non-root user
# cd /home/sergyi_gonchar_gmail_com/
# su - sergyi_gonchar_gmail_com
source /home/sergyi_gonchar_gmail_com/.bashrc


cd $SQOOP_HOME/conf

mv sqoop-env-template.sh  sqoop-env.sh

mv ${PROCAMP_DIR}/mysql-connector-java-8.0.22.jar $SQOOP_HOME/lib/

cp /usr/lib/hadoop-mapreduce/hadoop-mapreduce-client-*.jar $SQOOP_HOME/lib/
cp /usr/lib/hadoop-mapreduce/*.jar $SQOOP_HOME/lib/
cp /usr/lib/tez/*.jar $SQOOP_HOME/lib/



hdfs dfs -mkdir -p /hdp/apps/2.10.1/tez/
hdfs dfs -put -R /opt/gl-bigdata-procamp/apache-tez-0.9.2-bin /hdp/apps/2.10.1/tez/
hdfs dfs -chown -R root /hdp/apps/2.10.1/tez/
hdfs dfs -chmod -R 777 /hdp/apps/2.10.1/tez/

readonly PROCAMP_DIR=/opt/gl-bigdata-procamp
readonly SQOOP_BASE_DIR=/opt/sqoop
export SQOOP_HOME=${SQOOP_BASE_DIR}/sqoop-1.4.7.bin__hadoop-2.6.0
export PATH=$PATH:$SQOOP_HOME/bin



readonly PROCAMP_DIR=/opt/gl-bigdata-procamp
tar -xf ${PROCAMP_DIR}/apache-tez-0.9.2-bin.tar.gz -C ${PROCAMP_DIR}



printf 'export HADOOP_COMMON_HOME=/usr/lib/hadoop\n
export HADOOP_MAPRED_HOME=/usr/lib/hadoop-mapreduce\n
export HIVE_HOME=/usr/lib/hive\n
export ZOOCFGDIR=/usr/lib/zookeeper\n' >> /opt/sqoop/sqoop-1.4.7.bin__hadoop-2.6.0/conf/sqoop-env.sh


xmlstarlet ed -L -u '/configuration/property/value[0]' \
 -v '/hdp/apps/2.10.1/tez/tez.tar.gz,file:/usr/lib/tez,file:/usr/lib/tez/lib,file:/usr/local/share/google/dataproc/lib,hdfs:///apps/tez/,hdfs:///hdp/apps/2.10.1/tez/' \
 /etc/tez/conf/tez-site.xml

xmlstarlet ed -L -u '/configuration/property/value[0]' \
 -v 'hdfs:///hdp/apps/2.10.1/tez/tez.tar.gz,file:/usr/lib/tez,file:/usr/lib/tez/lib,file:/usr/local/share/google/dataproc/lib,hdfs:///apps/tez/' \
 /etc/tez/conf/tez-site.xml

file:/usr/lib/tez,file:/usr/lib/tez/lib,file:/usr/local/share/google/dataproc/lib,
xmlstarlet ed -L -u '/configuration/property[1]/value' \
 -v '/hdp/apps/2.10.1/tez/tez.tar.gz' \
 /etc/tez/conf/tez-site.xml


 xmlstarlet ed -L -u '/configuration/property[1]/value' \
 -v 'file:/usr/lib/tez,file:/usr/lib/tez/lib,file:/usr/local/share/google/dataproc/lib,/hdp/apps/2.10.1/tez/tez.tar.gz' \
 /etc/tez/conf/tez-site.xml


hdfs dfs -rm -R /user/root/CHARACTER_SETS
 xmlstarlet ed -L -u '/configuration/property[1]/value' \
 -v '/hdp/apps/2.10.1/tez/tez.tar.gz' \
 /etc/tez/conf/tez-site.xml

 hdfs dfs -rm -R /user/root/CHARACTER_SETS
 xmlstarlet ed -L -u '/configuration/property[1]/value' \
 -v '/hdp/apps/2.10.1/tez/' \
 /etc/tez/conf/tez-site.xml


file:/usr/lib/tez,file:/usr/lib/tez/lib,file:/usr/local/share/google/dataproc/lib


  xmlstarlet ed -L -u '/configuration/property[1]/value' \
 -v 'gs://dataproc-staging-bucket-565016fcd480cd09/google-cloud-dataproc-metainfo/tez/' \
 /etc/tez/conf/tez-site.xml

   xmlstarlet ed -L -u '/configuration/property[1]/value' \
 -v 'hdfs:///hdp/apps/2.10.1/tez/apache-tez-0.9.2-bin/' \
 /etc/tez/conf/tez-site.xml

xmlstarlet sel -t -c '/configuration/property/value[1]' -n  /etc/tez/conf/tez-site.xml


hdfs dfs -rm -R /user/root/CHARACTER_SETS

HADOOP_CLASSPATH="${HADOOP_CLASSPATH}:/usr/lib/tez/*:/usr/lib/tez/lib/*:/etc/tez/conf:"