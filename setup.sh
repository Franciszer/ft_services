# VARIABLES

# SETUP

minikube start --cpus=2 --memory 4000 --vm-driver=virtualbox --extra-config=apiserver.service-node-port-range=1-35000
minikube addons enable dashboard
minikube addons enable ingress
kubectl apply -f srcs/nginx_setup.yml
eval $(minikube docker-env)
docker build -t nginx_alpine srcs/nginx
kubectl apply -f srcs/ingress_setup.yml