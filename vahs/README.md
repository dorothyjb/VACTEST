# Setup

*NOTE:* This documentation assumes you're in the vahs directory.

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
sudo rm -f /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/welcome.conf
```

## Installing Phusion Passenger
```
cd /home/testing/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/passenger-5.1.2/bin
./passenger-install-apache2-module
```
*just keep hitting enter*

### Enable passenger access for SELinux
```
sudo setsebool -P httpd_read_user_content 1
sudo semodule -i ../apache/my-httpd.pp
sudo semodule -i ../apache/passenger.pp
sudo semodule -i ../apache/passenger-agent.pp
sudo semodule -i ../apache/utils-rb.pp
chcon -R -t httpd_sys_rw_content_t tmp
chcon -t httpd_sys_rw_content_t db/development.sqlite3
```

## Setting up SSL
```
sudo cp ../apache/vaca_fullpath.pem /etc/pki/tls/certs/
# The following line is for development purposes only.
sudo openssl req -x509 -newkey rsa:4096 -nodes -keyout /etc/ssl/certs/server.key -out /etc/pki/tls/certs/server.crt -days 365
```

## Restart apache
```
sudo systemctl restart httpd
```
*Enter certificate information*

# BVA Hearing Schedule
