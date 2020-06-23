#!/bin/sh

addgroup mysql mysql

if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	# chown -R mysql:mysql /run/mysqld
fi

if [ -d /var/lib/mysql/mysql ]; then
	echo 'MySQL data already exists'
else
	mysql_install_db --user=mysql

	tmp=`mktemp`

	cat << EOF > $tmp
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
EOF

	echo 'FLUSH PRIVILEGES;' >> $tmp

	/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 < $tmp
	rm -f $tmp
fi

sleep 5

exec /usr/bin/mysqld --user=mysql --console
