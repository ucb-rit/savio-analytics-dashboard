# Data to Postgres
Python scripts to:
- load job data from stdin into Postgres
- load CPU data from InfluxDB into Postgres

## Requirements
- Python 3
- [psycopg2](http://initd.org/psycopg/)
- [influxdb-python](https://github.com/influxdata/influxdb-python)

- Copy `influx_config.py.example` to `influx_config.py` and fill in appropriate fields.

```bash
../show-jobs-raw.sh $START_DATE $END_DATE | python3 jobs2pg.py
```

## Development
```bash
virtualenv .
source bin/activate
pip install -r requirements.txt
```
