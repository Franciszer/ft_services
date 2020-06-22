 #!/bin/sh

APPLIST="mysql nginx phpmyadmin wordpress ftps influxdb grafana telegraf"

# COLORS
GREEN='\033[0;32m'
LIGHT_BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

# SERVICE
function create_service()
{
	kubectl apply -f srcs/services/$@_service.yaml > logs/services/$@ 2>&1
	echo -e "${LIGHT_BLUE}Creating service $@...${NC}"
	sleep 2;
	echo -e "\r\033[1A                                "
	echo -e "\r\033[1A${GREEN}✓	$@ service successfully created${NC}"
}

# DEPLOYMENTS
function deploy()
{
	kubectl apply -f srcs/deployments/$@_deployment.yaml > logs/deployment/$@ 2>&1
	echo -e "${LIGHT_BLUE}Creating deployment $@...${NC}"
	sleep 2;
	while [[ $(kubectl get pods -l app=$@ -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
		sleep 1;
	done
	echo -e "\r\033[1A                 "
	echo -e "\r\033[1A${GREEN}✓	$@ deployment successfully created${NC}"
}

# DOCKER CONTAINERS
function build_container()
{
	echo -e "${LIGHT_BLUE}Building $@ container...${NC}"
	docker build -t $@_alpine srcs/$@ > logs/build/$@ 2>&1
	echo -e "\r\033[1A                 "
	echo -e "\r\033[1A${GREEN}✓	$@ container successfully built${NC}"
}

rm -rf logs > /dev/null 2>&1
rm -rf srcs/wordpress/files/wordpress-tmp.sql > /dev/null 2>&1
rm -rf srcs/nginx/files/index-tmp.html > /dev/null 2>&1
mkdir ./logs > /dev/null 2>&1
mkdir ./logs/build > /dev/null 2>&1
mkdir ./logs/deployment > /dev/null 2>&1
mkdir ./logs/services > /dev/null 2>&1


# SETTING UP MINIKUBE
minikube start --vm-driver=docker --extra-config=apiserver.service-node-port-range=1-35000
minikube addons enable metrics-server
minikube addons enable ingress
minikube addons enable dashboard

eval $(minikube docker-env)

# SET ENV VARIABLE
# MINIKUBE_IP=$(minikube ip)
MINIKUBE_IP="$(kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)"

cp srcs/wordpress/files/wordpress.sql srcs/wordpress/files/wordpress-tmp.sql
sed -i "s/MINIKUBE_IP/$MINIKUBE_IP/g" srcs/wordpress/files/wordpress-tmp.sql
cp srcs/ftps/scripts/start.sh srcs/ftps/scripts/start-tmp.sh
sed -i "s/MINIKUBE_IP/$MINIKUBE_IP/g" srcs/ftps/scripts/start-tmp.sh
cp srcs/nginx/files/index.html srcs/nginx/files/index-tmp.html
sed -i "s/MINIKUBE_IP/$MINIKUBE_IP/g" srcs/nginx/files/index-tmp.html
# cp srcs/deployments/telegraf_setup.yaml srcs/deployments/telegraf-tmp_setup.yaml
# sed -i "s/MINIKUBE_IP/$MINIKUBE_IP/g" srcs/deployments/telegraf-tmp_setup.yaml
cp srcs/telegraf/telegraf.conf srcs/telegraf/telegraf-tmp.conf
sed -i "s/MINIKUBE_IP/$MINIKUBE_IP/g" srcs/telegraf/telegraf-tmp.conf
sed -i "s/USER_TELEGRAF/telegraf/g" srcs/telegraf/telegraf-tmp.conf

# BUILDING CONTAINERS
echo -e "\n${YELLOW}____BUILDING CONTAINERS____${NC}\n"

for APP in $APPLIST
do
	build_container $APP
done


echo -e "\n${GREEN}ALL CONTAINERS BUILT${NC}"

echo -e "\n${YELLOW}____CREATING SERVICES____\n${NC}"

for APP in $APPLIST
do
	create_service $APP
done

echo -e "\n${GREEN}ALL SERVICES CREATED${NC}\n"

# SERVICES DEPLOYMENTS

echo -e "\n${YELLOW}____CREATING DEPLOYMENTS____\n${NC}"

for APP in $APPLIST
do
	deploy $APP
done

kubectl apply -f srcs/deployments/ingress.yaml > /dev/null

echo -e "\n${GREEN}ALL DEPLOYMENTS CREATED${NC}\n"

kubectl exec -i $(kubectl get pods | grep mysql | cut -d" " -f1) -- mysql -u root -e 'CREATE DATABASE wordpress;'
kubectl exec -i $(kubectl get pods | grep mysql | cut -d" " -f1) -- mysql wordpress -u root < srcs/wordpress/files/wordpress-tmp.sql

rm -f srcs/wordpress/files/wordpress-tmp.sql
rm -f srcs/telegraf/telegraf-tmp.conf
rm -f srcs/nginx/files/index-tmp.html
# rm -f srcs/deployments/telegraf-tmp_setup.yaml

minikube service list
