## Spark Dataframes


### Decision using Python 
1) lab1-1-with-partitions.py  (bigdata-tools/spark/dataframes/python-dataframes/lab1-1-with-partitions.py)
    calculates the most popular destination airport per month and save to hdfs in TSV format
    Window functions are used for calculations
    
    To run in Dataproc cluster modify the next file with corresponding input and output paths  
    _bigdata-tools/hw/hw6-spark-dataframes-python/submitLab1-1-cloud.sh_

    
   lab1-2-with-groupby.py  (bigdata-tools/spark/dataframes/python-dataframes/lab1-2-with-groupby.py)
    calculates the most popular destination airport per month and save to hdfs in TSV format
    Group by and window functions are used for calculations
    
   To run in Dataproc cluster modify the next file with corresponding input and output paths  
    _bigdata-tools/hw/hw6-spark-dataframes-python/submitLab1-2-cloud.sh_

2) lab2.py  (bigdata-tools/spark/dataframes/python-dataframes/lab2.py)
    calculates percentage of canceled flights per origin airport per airline. 
    Saves the result to HDFS in json format sorted by airline name and percentage for all airports but 'Waco Regional Airport' which should be stored in CSV format. 
     
     To run in Dataproc cluster modify the next file with corresponding input and output paths  
     _bigdata-tools/hw/hw6-spark-dataframes-python/submitLab2-cloud.sh_
