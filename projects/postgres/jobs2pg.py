#!/bin/python3.6
# This script reads job input data from standard input and loads it into postgres
# The input format is delimited by | and fields listed below in the code

import fileinput
import datetime
import psycopg2
conn = psycopg2.connect(dbname='grafana')
cur = conn.cursor()

cur.execute("""CREATE TABLE IF NOT EXISTS jobs (
  job_id TEXT PRIMARY KEY,
  account TEXT,
  type TEXT,
  department TEXT,
  cpus INTEGER,
  partition TEXT,
  state TEXT,
  req_nodes INTEGER,
  alloc_nodes INTEGER,
  raw_time DOUBLE PRECISION,
  cpu_time DOUBLE PRECISION, 
  start_time TIMESTAMP WITH TIME ZONE, 
  end_time TIMESTAMP WITH TIME ZONE);""")
cur.execute("""CREATE TABLE IF NOT EXISTS job_nodes (
  job_id TEXT,
  hostname TEXT);""")
cur.execute("""CREATE TABLE IF NOT EXISTS cpu (
  timestamp TIMESTAMP WITH TIME ZONE,
  host TEXT,
  cpu TEXT,
  usage_guest_nice DOUBLE PRECISION,
  usage_idle DOUBLE PRECISION,
  usage_iowait DOUBLE PRECISION,
  usage_irq DOUBLE PRECISION,
  usage_nice DOUBLE PRECISION,
  usage_softirq DOUBLE PRECISION,
  usage_steal DOUBLE PRECISION,
  usage_system DOUBLE PRECISION,
  usage_user DOUBLE PRECISION);""")

line_count = 0
for line in fileinput.input():
  # job_id|account|type|department|cpus|partition|state|req_nodes|alloc_nodes|raw_time|cpu_time|end_time|start_time|node_list
  parts = line.split('|')
  job_id = parts[0]
  account = parts[1]
  account_type = parts[2]
  department = parts[3]
  cpus = parts[4]
  partition = parts[5]
  state = parts[6]
  req_nodes = parts[7]
  alloc_nodes = parts[8]
  raw_time = float(parts[9])
  cpu_time = float(parts[10])
  end_time = datetime.datetime.utcfromtimestamp(int(parts[11]))
  start_time = datetime.datetime.utcfromtimestamp(int(parts[12]))
  nodes = parts[13].split(',')

  # Update the data associated with a job if newer data is given
  # Source: https://stackoverflow.com/a/6527838
  cur.execute("""UPDATE jobs 
    SET account=%s, type=%s, department=%s, cpus=%s, partition=%s, state=%s, req_nodes=%s, alloc_nodes=%s, raw_time=%s, cpu_time=%s, start_time=%s, end_time=%s
    WHERE job_id=%s;""", 
    (account, account_type, department, cpus, partition, state, req_nodes, alloc_nodes, raw_time, cpu_time, start_time, end_time, job_id))
  cur.execute("""INSERT INTO jobs (
      job_id, account, type, department, cpus, partition, state, req_nodes, alloc_nodes, raw_time, cpu_time, start_time, end_time
    ) SELECT %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s
    WHERE NOT EXISTS (SELECT 1 FROM jobs WHERE job_id = %s);""", (job_id, account, account_type, department, cpus, partition, state, req_nodes, alloc_nodes, raw_time, cpu_time, start_time, end_time, job_id))

  cur.execute("""DELETE FROM job_nodes WHERE job_id = %s;""", (job_id,)) # In case duplicates come
  if nodes and nodes[0]:
      for node in nodes:
        cur.execute("""INSERT INTO job_nodes (job_id, hostname) VALUES (%s, %s);""", (job_id, node))
  line_count += 1

conn.commit()
cur.close()
conn.close()

print('Inserted {} rows'.format(line_count))
