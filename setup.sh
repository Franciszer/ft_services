 #!/bin/sh

SERVICES="mysql phpmyadmin nginx wordpress"
CONTAINERS="mysql wordpress nginx"

# COLORS
GREEN='\033[0;32m'
LIGHT_BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

function deploy()
{
	kubectl apply -f srcs/deployments/$@_setup.yaml > /dev/null
	echo -e "${LIGHT_BLUE}Deploying $@...${NC}"
	sleep 2;
	while [[ $(kubectl get pods -l app=$@ -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
		sleep 1;
	done
	echo -e "\r\033[1A                 "
	echo -e "\r\033[1A${GREEN}✓	$@ deployed successfully${NC}"
}

function build_container()
{
	echo -e "${LIGHT_BLUE}Building $@ container...${NC}"
	docker build -t $@_alpine srcs/$@ > /dev/null
	echo -e "\r\033[1A                 "
	echo -e "\r\033[1A${GREEN}✓	$@ container successfully built${NC}"
}

minikube start --cpus=2 --memory 4000 --vm-driver=virtualbox --extra-config=apiserver.service-node-port-range=1-35000
minikube addons enable metrics-server
minikube addons enable ingress
minikube addons enable dashboard

MINIKUBE_IP=$(minikube ip)

eval $(minikube docker-env)


cp srcs/WordPress/files/wordpress.sql srcs/WordPress/files/wordpress-tmp.sql
sed -i '' "s/MINIKUBE_IP/$MINIKUBE_IP/g" srcs/WordPress/files/wordpress-tmp.sql
cp srcs/ftps/scripts/start.sh srcs/ftps/scripts/start-tmp.sh
sed -i '' "s/MINIKUBE_IP/$MINIKUBE_IP/g" srcs/ftps/scripts/start-tmp.sh

# BUILDING CONTAINERS
echo -e "\n${YELLOW}__BUILDING CONTAINERS__${NC}\n"
for CONTAINER in $CONTAINERS
do
	build_container $CONTAINER
done

echo -e "\n${GREEN}ALL CONTAINERS BUILT${NC}\n"

# docker build -t mysql_alpine srcs/mysql
# docker build -t wordpress_alpine srcs/wordpress
# docker build -t nginx_alpine srcs/nginx

# SERVICES DEPLOYMENTS

echo -e "\n${YELLOW}__DEPLOYING SERVICES__\n${NC}\n"

for SERVICE in $SERVICES
do
	deploy $SERVICE
done

kubectl apply -f srcs/deployments/ingress_setup.yaml > /dev/null

echo -e "\n${GREEN}ALL SERVICES DEPLOYED${NC}\n"

# kubectl apply -f srcs/mysql.yaml
# kubectl apply -f srcs/phpmyadmin.yaml
# kubectl apply -f srcs/nginx_setup.yaml
# kubectl apply -f srcs/wordpress.yaml
# kubectl apply -f srcs/ingress_setup.yaml

kubectl exec -i $(kubectl get pods | grep mysql | cut -d" " -f1) -- mysql -u root -e 'CREATE DATABASE wordpress;'
kubectl exec -i $(kubectl get pods | grep mysql | cut -d" " -f1) -- mysql wordpress -u root < srcs/WordPress/files/wordpress-tmp.sql

rm -rf srcs/wordpress/files/wordpress-tmp.sql
# kubectl	apply -f srcs/ftps.yaml
# docker build -t ftps_alpine srcs/ftps