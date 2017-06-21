```
cd ssl
./new-cert
# enter necessary information
```

# Configuring the database
```
cp vahs/config/database.yml.sample vahs/config/database.yml
# modify database.yml to use the necessary username, password, hostname,
# and port information.
```

# Starting thin
```
cd vahs
export NLS_LANG="American_America.UTF8"
thin start --ssl --ssl-cert-file ../ssl/vahs.crt --ssl-key-file ../ssl/vahs.key
```
