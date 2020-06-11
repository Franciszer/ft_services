
# INSTALL & UPDATE
apt-get update > /dev/null 2>&1
apt-get install -y wget > /dev/null 2>&1
apt-get install -y nginx > /dev/null 2>&1
echo "nginx installed"
apt-get install -y openssl > /dev/null 2>&1
echo "Openssl installed"
apt-get install -y zip > /dev/null 2>&1
echo "Zip installed"

# SITE LINKING
ln -s /etc/nginx/sites-available/server.config /etc/nginx/sites-enabled/
chown -R www-data:www-data /var/www/*
chmod -R 755 /var/www/*

# SSL
mkdir ~/mkcert && \
  cd ~/mkcert && \
  wget https://github.com/FiloSottile/mkcert/releases/download/v1.1.2/mkcert-v1.1.2-linux-amd64 && \
  mv mkcert-v1.1.2-linux-amd64 mkcert && \
  chmod +x mkcert
./mkcert -install
./mkcert localhost

# START
service nginx start
