 #!/bin/sh

SERVICES="mysql phpmyadmin nginx wordpress ftps telegraf influxdb grafana"
CONTAINERS="mysql wordpress nginx ftps grafana"

# COLORS
GREEN='\033[0;32m'
LIGHT_BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

# DEPLOYMENTS
function deploy()
{
	kubectl apply -f srcs/deployments/$@_setup.yaml > logs/deployment/$@.txt 2>&1
	echo -e "${LIGHT_BLUE}Deploying $@...${NC}"
	sleep 2;
	while [[ $(kubectl get pods -l app=$@ -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
		sleep 1;
	done
	echo -e "\r\033[1A                 "
	echo -e "\r\033[1A${GREEN}✓	$@ deployed successfully${NC}"
}

# DOCKER CONTAINERS
function build_container()
{
	echo -e "${LIGHT_BLUE}Building $@ container...${NC}"
	docker build -t $@_alpine srcs/$@ > logs/build/$@.txt 2>&1
	echo -e "\r\033[1A                 "
	echo -e "\r\033[1A${GREEN}✓	$@ container successfully built${NC}"
}

rm -rf logs > /dev/null 2>&1

# SETTING UP MINIKUBE
minikube start --cpus=2 --memory 4000 --vm-driver=virtualbox --extra-config=apiserver.service-node-port-range=1-35000
minikube addons enable metrics-server
minikube addons enable ingress
minikube addons enable dashboard

# SET ENV VARIABLE
MINIKUBE_IP=$(minikube ip)

eval $(minikube docker-env)

mkdir ./logs
mkdir ./logs/build
mkdir ./logs/deployment
cp srcs/WordPress/files/wordpress.sql srcs/WordPress/files/wordpress-tmp.sql
sed -i '' "s/MINIKUBE_IP/$MINIKUBE_IP/g" srcs/WordPress/files/wordpress-tmp.sql
cp srcs/ftps/scripts/start.sh srcs/ftps/scripts/start-tmp.sh
sed -i '' "s/MINIKUBE_IP/$MINIKUBE_IP/g" srcs/ftps/scripts/start-tmp.sh

# BUILDING CONTAINERS
echo -e "\n${YELLOW}____BUILDING CONTAINERS____${NC}\n"
for CONTAINER in $CONTAINERS
do
	build_container $CONTAINER
done

echo -e "\n${GREEN}ALL CONTAINERS BUILT${NC}"

# SERVICES DEPLOYMENTS

echo -e "\n${YELLOW}____DEPLOYING SERVICES____\n${NC}"

for SERVICE in $SERVICES
do
	deploy $SERVICE
done

kubectl apply -f srcs/deployments/ingress_setup.yaml > /dev/null

echo -e "\n${GREEN}ALL SERVICES DEPLOYED${NC}\n"

kubectl exec -i $(kubectl get pods | grep mysql | cut -d" " -f1) -- mysql -u root -e 'CREATE DATABASE wordpress;'
kubectl exec -i $(kubectl get pods | grep mysql | cut -d" " -f1) -- mysql wordpress -u root < srcs/WordPress/files/wordpress-tmp.sql

rm -rf srcs/wordpress/files/wordpress-tmp.sql

minikube service list
