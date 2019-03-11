#!/bin/env python

from influxdb import InfluxDBClient
import influx_config
client = InfluxDBClient(influx_config.hostname, influx_config.port, influx_config.table, influx_config.password, influx_config.database, ssl=True, verify_ssl=False)

# '('cpu', {'host': 'n0301.savio2'})': [{'time': '2019-02-25T21:37:00Z', 'usage_guest': 0, 'usage_guest_nice': 0, 'usage_idle': 0.01458302953377833, 'usage_iowait': 0, 'usage_irq': 0, 'usage_nice': 0, 'usage_softirq': 0.004166579862909589, 'usage_steal': 0, 'usage_system': 1.8624611987227653, 'usage_user': 98.11878919174328}]

cpu_data = client.query("""SELECT "usage_guest", "usage_guest_nice", "usage_idle", "usage_iowait", "usage_irq", "usage_nice", "usage_softirq", "usage_steal", "usage_system", "usage_user" FROM "short"."cpu" WHERE time >= now() - 25h GROUP BY host""")

import psycopg2
conn = psycopg2.connect(dbname='grafana')
cur = conn.cursor()

cur.execute("""CREATE TABLE IF NOT EXISTS cpu (
  timestamp TIMESTAMP WITH TIME ZONE,
  host TEXT,
  cpu TEXT,
  usage_guest DOUBLE PRECISION,
  usage_guest_nice DOUBLE PRECISION,
  usage_idle DOUBLE PRECISION,
  usage_iowait DOUBLE PRECISION,
  usage_irq DOUBLE PRECISION,
  usage_nice DOUBLE PRECISION,
  usage_softirq DOUBLE PRECISION,
  usage_steal DOUBLE PRECISION,
  usage_system DOUBLE PRECISION,
  usage_user DOUBLE PRECISION);""")

def make_transfer_row(host):
    def transfer_row(result):
        cur.execute('DELETE FROM cpu WHERE host = %s AND timestamp = %s;', (host, result['time'])) # In case duplicates come
        cur.execute('INSERT INTO cpu (timestamp, host, usage_guest, usage_guest_nice, usage_idle, usage_iowait, usage_irq, usage_nice, usage_softirq, usage_steal, usage_system, usage_user) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);', (result['time'], host, result['usage_guest'], result['usage_guest_nice'], result['usage_idle'], result['usage_iowait'], result['usage_irq'], result['usage_nice'], result['usage_softirq'], result['usage_steal'], result['usage_system'], result['usage_user']))
    return transfer_row

def transfer_host(item):
    host, data = item[0][1]['host'], item[1]
    for row in data:
        make_transfer_row(host)(row)
    print('Processed', host)

def transfer(point):
    host, values = point['tags']['host'], point['values'][0]
    cur.execute('DELETE FROM cpu WHERE host = %s AND timestamp = %s;', (host, values[0])) # In case duplicates come
    cur.execute('INSERT INTO cpu (host, timestamp, usage_guest, usage_guest_nice, usage_idle, usage_iowait, usage_irq, usage_nice, usage_softirq, usage_steal, usage_system, usage_user) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);', [host] + values)

# {'name': 'cpu', 'tags': {'host': 'n0301.savio2'}, 'columns': ['time', 'usage_guest', 'usage_guest_nice', 'usage_idle', 'usage_iowait', 'usage_irq', 'usage_nice', 'usage_softirq', 'usage_steal', 'usage_system', 'usage_user'], 'values': [['2019-02-25T22:29:00Z', 0, 0, 0.0187500000174623, 0, 0, 0, 0.0020833333333314386, 0, 1.887499999999515, 98.09166666663562]]}]}
for item in cpu_data.items():
    transfer_host(item) 
    conn.commit()

cur.close()
conn.close()
