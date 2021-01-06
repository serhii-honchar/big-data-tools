## NiFi

#### 1.1. RUNNING NIFI CLUSTER

To start a nifi cluster, run 'createInfrastructure.sh' in the project root directory. 
By default nifi containers will be available on the range of ports from 30090 to 30092.
To destroy nifi cluster and remove all containers, run 'destroyInfrastructure.sh' located in the root directory of the project
 
 
##### 1.2. RUNNING A SINGLE NIFI INSTANSE

If one needs to launch a single nifi instance, it's required to run 'run.sh' file located in ./nifi folder.   


#### 1.3. BACKUP NIFI CONFIGURATION

Launch 'backupFlowFile.sh' to backup flow.xml.gz from running container.
It copies the mentioned file to ./nifi/dump folder and adds suffix with current timestamp


#### 1.4. RESTORE NIFI CONFIGURATION

Remove 'mynifi' image from local Docker registry  - run 'docker rmi ${IMAGE_ID}' 
Copy/move backup file to ./nifi/conf directory named flow.xml.gz.
Now one can run single nifi instance or cluster with updated configuration
