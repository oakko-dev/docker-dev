# docker-dev
Docker file with dev starter

docker-compose -p docker-dev up -d

docker exec -it --user root [container_name] bash ## docker exec -it --user root docker-dev-mssql-1 bash
chmod 777 [path_to_change_permisison] ## chmod 777 backups/