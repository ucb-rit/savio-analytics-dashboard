# Job Data to Postgres
Python script to load job data from stdin into Postgres

## Requirements
- Python 3
- [psycopg2](http://initd.org/psycopg/)

```bash
../show-jobs-raw.sh $START_DATE $END_DATE | python3 jobs2pg.py
```

## Development
```bash
virtualenv .
source bin/activate
pip install -r requirements.txt
```
