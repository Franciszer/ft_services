 #!/bin/sh

APPLIST="mysql wordpress ftps nginx phpmyadmin influxdb grafana"
FTPS_IP=172.17.0.21

# COLORS
GREEN='\033[0;32m'
LIGHT_BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

# DEPLOYMENTS
function deploy()
{
	kubectl apply -f srcs/deployments/$@_deployment.yaml > logs/deployment/$@ 2>&1
	echo -e "${LIGHT_BLUE}Creating deployment $@...${NC}"
	sleep 2;
	while [[ $(kubectl get pods -l app=$@ -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
		sleep 1;
	done
	echo -e "\r\033[1A                            "
	echo -e "\r\033[1A${GREEN}✓	$@ deployment successfully created${NC}"
}

# DOCKER CONTAINERS
function build_container()
{
	echo -e "${LIGHT_BLUE}Building $@ container...${NC}"
	if [[ $@ == 'ftps' ]]
	then
		docker build -t $@_alpine srcs/$@ --build-arg IP=${FTPS_IP} > logs/build/$@ 2>&1
	else
		docker build -t $@_alpine srcs/$@ > logs/build/$@ 2>&1
	fi
	echo -e "\r\033[1A                                                            "
	echo -e "\r\033[1A${GREEN}✓	$@ container successfully built${NC}"
}

# CLEAN
function clean_app()
{
	kubectl delete -f srcs/deployments/$@_deployment.yaml > /dev/null 2>&1
	kubectl delete -f srcs/services/$@_service.yaml > /dev/null 2>&1
}

if [[ $1 == 'clean' ]]
then
	printf "${LIGHT_BLUE}➜	Cleaning all deployments and services...\n${NC}"
	rm -rf logs
	for APP in $APPLIST
	do
		clean_app $APP
	done
	kubectl delete -f srcs/deployments/ingress.yaml > /dev/null 2>&1
	echo -e "\r\033[1A                                                             "
	echo -e "\r\033[1A${GREEN}✓	Clean complete !${NC}"
	exit
fi


# SERVICE
function create_service()
{
	kubectl apply -f srcs/services/$@_service.yaml > logs/services/$@ 2>&1
	echo -e "${LIGHT_BLUE}Creating service $@...${NC}"
	sleep 2;
	echo -e "\r\033[1A                                "
	echo -e "\r\033[1A${GREEN}✓	$@ service successfully created${NC}"
}

# RESETING LOG FILES
rm -rf logs > /dev/null 2>&1
mkdir ./logs > /dev/null 2>&1
mkdir ./logs/build > /dev/null 2>&1
mkdir ./logs/deployment > /dev/null 2>&1
mkdir ./logs/services > /dev/null 2>&1


# SETTING UP MINIKUBE
if [[ $(minikube status | grep -c "Running") == 0 ]]
then
	minikube start --vm-driver=docker
	minikube addons enable metrics-server
	minikube addons enable dashboard
fi

eval $(minikube docker-env)

# SETTING UP METALLB
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml
kubectl create -f srcs/configmap.yml

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

kubectl exec -i $(kubectl get pods | grep mysql | cut -d" " -f1) -- mysql wordpress -u root < srcs/mysql/srcs/wordpress.sql

echo -e "\n${GREEN}ALL DEPLOYMENTS CREATED${NC}\n"

kubectl get services

#minikube dashboard &