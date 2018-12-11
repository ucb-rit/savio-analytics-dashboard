# BRC Dashboard TIG Stack
This Vagrant configuration sets up the TIG stack in a VM using Docker. This is for testing data input collection scripts and loading test data. Historical data can be loaded by putting it in `scripts/mock/collected.txt`.

- TIG Stack: Telegraf, InfluxDB, Grafana

## Running
From this `vagrant` directory:
```bash
vagrant up
vagrant provision
```
and then navigate to `http://localhost:3000`.


Default Grafana login:
```
username: admin
password: admin
```

Add data source:
```
name: influxdb
url: http://influxdb:8086
database: telegraf
```
Authentication can be left blank.

