# Savio Analytics Dashboard Scripts
Collection of scripts to collect data for the Telegraf/InfluxDB/Grafana stack and display useful information about the Savio cluster.

## Running
There are two main scripts to run:
- `main.sh`: Collects data quickly and can be run every 10 seconds
- `slow.sh`: Collects data that takes a long time, should be run once per day
