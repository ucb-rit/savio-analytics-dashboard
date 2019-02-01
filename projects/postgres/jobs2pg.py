import fileinput
for line in fileinput.input():
  # job_id|account|type=|department|cpus|partition|state|req_nodes|alloc_nodes|raw_time|cpu_time|end_time
  print(line.split('|'))

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

