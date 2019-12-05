#!/usr/bin/env python
import requests

from influxdb import InfluxDBClient
import influx_config
import rest_config

client = InfluxDBClient(influx_config.hostname, influx_config.port, influx_config.table, influx_config.password, influx_config.database, ssl=True, verify_ssl=False)

# '('cpu', {'host': 'n0301.savio2'})': [{'time': '2019-02-25T21:37:00Z', 'usage_guest': 0, 'usage_guest_nice': 0, 'usage_idle': 0.01458302953377833, 'usage_iowait': 0, 'usage_irq': 0, 'usage_nice': 0, 'usage_softirq': 0.004166579862909589, 'usage_steal': 0, 'usage_system': 1.8624611987227653, 'usage_user': 98.11878919174328}]

cpu_data = client.query("""SELECT "usage_guest", "usage_guest_nice", "usage_idle", "usage_iowait", "usage_irq", "usage_nice", "usage_softirq", "usage_steal", "usage_system", "usage_user" FROM "short"."cpu" WHERE time >= now() - 25h GROUP BY host""")

# {'name': 'cpu', 'tags': {'host': 'n0301.savio2'}, 'columns': ['time', 'usage_guest', 'usage_guest_nice', 'usage_idle', 'usage_iowait', 'usage_irq', 'usage_nice', 'usage_softirq', 'usage_steal', 'usage_system', 'usage_user'], 'values': [['2019-02-25T22:29:00Z', 0, 0, 0.0187500000174623, 0, 0, 0, 0.0020833333333314386, 0, 1.887499999999515, 98.09166666663562]]}]}
flattened_data = []
for item in cpu_data.items():
    host, data = item[0][1]['host'], item[1]
    for row in data:
        row['timestamp'] = row['time']
        del row['time']
        row['host'] = { 'name': host }
        flattened_data.append(row)

# Based on Matthew's example code for using his CPU batch API
import json
import zipfile
from io import BytesIO 

buf = BytesIO()
with zipfile.ZipFile(buf, mode='w', compression=zipfile.ZIP_DEFLATED) as zip_file:
    contained_file = BytesIO()
    contained_file.write(json.dumps(flattened_data).encode())
    zip_file.writestr("cpu_data.json", contained_file.getvalue())
buf.seek(0)
headers = {'Authorization': rest_config.TOKEN}
r = requests.put(rest_config.MYBRC_REST_URL + '/upload_cpu_data/cpu_data.zip', files={"file": buf}, headers=headers)
print(r)
print(r.text)
