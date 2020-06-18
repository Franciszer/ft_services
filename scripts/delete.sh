rm -rf logs > /dev/null 2>&1
rm -rf srcs/wordpress/files/wordpress-tmp.sql > /dev/null 2>&1
rm -rf srcs/nginx/files/index-tmp.html > /dev/null 2>&1
minikube delete && minikube delete
