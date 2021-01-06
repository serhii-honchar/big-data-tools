sudo snap install docker

docker run \
  --name mysql \
  -e MYSQL_ROOT_PASSWORD=password4root \
  -e MYSQL_USER=userdev1 \
  -e MYSQL_PASSWORD=password4dev1 \
  -p 13306:3306 \
  -d mysql:5.7


#mysql -h localhost -P 13306 --protocol=tcp -u userdev1  -p
