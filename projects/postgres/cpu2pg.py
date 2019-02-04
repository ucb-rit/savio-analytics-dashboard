#!/bin/python3.6

from influxdb import InfluxDBClient
client = InfluxDBClient('localhost', 8086, 'root', 'root', 'example')

cpu_data = client.query("""SELECT mean(*) 
    FROM "short"."cpu" 
    WHERE time >= now() - 5m 
    GROUP BY time(10s), "host" fill(null)""")
