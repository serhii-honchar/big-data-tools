
Template in this directory has two flows to process the data from websocket subscription:
1) central flow - saves each flow file separately in the directories named according to the provided pattern.
2) right flow - uses merging content processor that merges all flow files received during one minute into one file. Thus, each directory in /home/nifi/merged/  directory will contain only one file.
