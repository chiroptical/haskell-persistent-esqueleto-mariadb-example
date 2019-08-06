# persistent + esqueleto + mariadb

I was trying to create a very simple example of `persistent` and `esqueleto`
running queries for `mariadb`. I built this using motivation from:

- https://github.com/jhb563/ProdHaskellSeries/blob/master/src/Database.hs
- https://github.com/yesodweb/yesod-cookbook/blob/master/cookbook/Example-MySQL-Connection-code.md
- http://hackage.haskell.org/package/esqueleto

## Running mariadb on Pop!\_OS 19.04

First, we need to install some dependencies. Second, the `mysql` package
expects `mysql_config` to be in our path.

```
sudo apt install libmariadb-dev mariadb-server
sudo ln -s /usr/bin/mariadb_config /usr/bin/mysql_config
sudo systemctl start mariadb
```

## Create username, credentials, and database

- `YOUR_USERNAME` below is the username on your machine
- `YOUR_PASSWORD` can be whatever you like
- `YOUR_DATABASE` can be whatever you like

```
bash> sudo mysql
mariadb> grant all privelages on YOUR_DATABASE.* to 'YOUR_USERNAME'@'localhost';
```

TODO
