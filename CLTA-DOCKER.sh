# ---------------- COMANDOS BASICOS DOCKER ---------------- #

sudo docker ps # COMPROMAR LOS CONTENEDORES ACTIVOS
sudo docker run # LEVANTAR EL CONTENEDOR CON DOCKER
sudo docker rm [nombreContenedor o ID] # BORRAR UN CONTENEDOR DOCKER
sudo docker-compose up -d # LEVANTAR EL DOCKER COMPOSE
sudo docker exec -it -u root [IDCONTENEDOR] bash # ACCEDER A LA CONSOLA DEL CONTENEDORES
docker inspect nombre_del_contenedor | grep IPAddress # VER IP DE UN CONTENEDOR
sudo docker-compose down # TIRAR SERVIDOR WEB

# ---------------- LEVANTAR CONTENEDORES ---------------- #

## LEVANTAR PHPMYADMIN (DOCKER) ##

docker network create phpmyadmin-network
docker run -d --name phpmyadmin -p 8081:80 --network phpmyadmin-network -e PMA_HOST=bbddCompra phpmyadmin

## LEVANTAR LA BASE DE DATOS Mariadb(DOCKER) ##

docker run -d --name miBase -v mysql-data:/var/lib/mysql --network phpmyadmin-network -e "MYSQL_ROOT_PASSWORD=Hola1234" mariadb [OPCIONAL]
docker volume create mysql-data [OPCIONAL]
docker run -p 3306:3306 --name bbddCompra -v /home/BBDDCOMPRA:/var/lib/mysql --network phpmyadmin-network -e MYSQL_ROOT_PASSWORD=Hola1234 -d mariadb [BUENO]

## LEVANTAR UN SERVIDOR WEB CON APACHE (DOCKER) ##

docker volume create apache-data [OPCIONAL]
docker run -d --name apache-server -p 80:80 httpd [OPCIONAL]
docker run -p 8080:80 -v /home/PROYECTOCOMPRACASA:/var/www/html --name compraCasaWeb -d --network phpmyadmin-network php:7.4-apache [BUENO]

## LEVANTAR OCTOPRINT ##

docker volume create octoprint
docker run -d -v octoprint:/octoprint --device /dev/ttyACM0:/dev/ttyACM0 --device /dev/video0:/dev/video0 -e ENABLE_MJPG_STREAMER=true -p 8082:80 --name octoprint octoprint/octoprint


## SCRIPT INICIO DE SESION ##

sudo docker restart compraCasaWeb
sudo docker restart bbddCompra
sudo docker restart phpmyadmin
sudo systemctl restart smbd

## ---------------- LEVANTAR SERVIDOR WEB CON NGINX Y BBDD (EN DOCKER-COMPOSE) ---------------- ##

web:
  image: nginx
  volumes:
   - ./templates:/etc/nginx/templates
  ports:
   - "8080:80"
  environment:
   - NGINX_HOST=foobar.com
   - NGINX_PORT=80
