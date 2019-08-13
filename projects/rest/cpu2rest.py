#!/usr/bin/env python
import requests

from influxdb import InfluxDBClient
import influx_config
client = InfluxDBClient(influx_config.hostname, influx_config.port, influx_config.table, influx_config.password, influx_config.database, ssl=True, verify_ssl=False)

# '('cpu', {'host': 'n0301.savio2'})': [{'time': '2019-02-25T21:37:00Z', 'usage_guest': 0, 'usage_guest_nice': 0, 'usage_idle': 0.01458302953377833, 'usage_iowait': 0, 'usage_irq': 0, 'usage_nice': 0, 'usage_softirq': 0.004166579862909589, 'usage_steal': 0, 'usage_system': 1.8624611987227653, 'usage_user': 98.11878919174328}]

cpu_data = client.query("""SELECT "usage_guest", "usage_guest_nice", "usage_idle", "usage_iowait", "usage_irq", "usage_nice", "usage_softirq", "usage_steal", "usage_system", "usage_user" FROM "short"."cpu" WHERE time >= now() - 25h GROUP BY host""")

def make_transfer_row(host):
    def transfer_row(result):
        result['timestamp'] = result['time']
        requests.post('http://scgup-dev.lbl.gov:8888/mybrc-rest/cpus/', data=result)
    return transfer_row

def transfer_host(item):
    host, data = item[0][1]['host'], item[1]
    for row in data:
        make_transfer_row(host)(row)
    print('Processed', host)

# {'name': 'cpu', 'tags': {'host': 'n0301.savio2'}, 'columns': ['time', 'usage_guest', 'usage_guest_nice', 'usage_idle', 'usage_iowait', 'usage_irq', 'usage_nice', 'usage_softirq', 'usage_steal', 'usage_system', 'usage_user'], 'values': [['2019-02-25T22:29:00Z', 0, 0, 0.0187500000174623, 0, 0, 0, 0.0020833333333314386, 0, 1.887499999999515, 98.09166666663562]]}]}
for item in cpu_data.items():
    transfer_host(item) 
    conn.commit()

cur.close()
conn.close()
