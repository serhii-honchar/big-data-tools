## Spark RDD


### Decision using Python 
1) lab1.py  (bigdata-tools/spark/rdd/python/lab1.py)
    calculates the most popular destination airport per month and save to hdfs in TSV format
    
    To run in Dataproc cluster modify the next file with corresponding input and output paths  
    _bigdata-tools/hw/hw5-spark-rdd-python/submitLab1-cloud.sh_

2) lab2.py  (bigdata-tools/spark/rdd/python/lab2.py)
    calculates percentage of canceled flights per origin airport per airline. 
    Saves the result to HDFS in json format sorted by airline name and percentage for all airports but 'Waco Regional Airport' which should be stored in CSV format. 
     
     To run in Dataproc cluster modify the next file with corresponding input and output paths  
     _bigdata-tools/hw/hw5-spark-rdd-python/submitLab2-cloud.sh_
