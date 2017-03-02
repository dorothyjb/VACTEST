# Setup

## Update packages to latest.
```
sudo yum update
```

## Install Apache (and SSL module)
```
sudo yum install httpd mod_ssl
```

## Install mysql (mariadb)
```
sudo yum install mariadb mariadb-server mariadb-devel
```

### Set password for rails app.
```
sudo -i
mysqld_safe --skip-grant-tables &
mysql
use mysql;
UPDATE user SET password=PASSWORD("classic1") WHERE User='root';
FLUSH PRIVILEGES;
quit;
kill %1
```

## Add httpd and mariadb to auto startup
```
sudo systemctl enable httpd.service
sudo systemctl enable mariadb.service
```

## Open firewall ports (if necessary)
```
sudo firewall-cmd --zone=public --add-port=3000/tcp --permanent
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
sudo firewall-cmd --zone=public --add-port=443/tcp --permanent
sudo firewall-cmd --reload
```

## Ensure latest gems
```
bundle install
```

## Testing the rails Application
```
./bin/rails server -b 0.0.0.0
```
 * The application should now be accessible at http://localhost:3000/

## Configuring Apache
```
sudo cp ../apache/httpd.conf /etc/httpd/conf/
sudo cp ../apache/tdd.conf /etc/httpd/conf.d/
sudo cp ../apache/ssl.conf /etc/httpd/conf.d/
```

## Installing Phusion Passenger

### TODO

# BVA Hearing Schedule
