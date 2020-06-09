# VARIABLES

# SETUP

minikube start --cpus=2 --memory 4000 --vm-driver=virtualbox --extra-config=apiserver.service-node-port-range=1-35000
minikube addons enable dashboard
kubectl apply -f srcs/nginx_setup.yaml
kubectl apply -f srcs/ingress_setup.yaml
eval $(minikube docker-env)
docker build -t nginx_alpine srcs/nginx