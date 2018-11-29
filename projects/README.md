# Savio Projects
These scripts help map the project account to the department of the project PI so that job/usage data can be correlated with department. Our SLURM database doesn't include department or the email of the PI.

## How it works
1. Download the projects spreadsheets and the project requests spreadsheets for each year. The projects speadsheet should be named `BRC-Projects - All-Projects.csv` and the project requests should be a .csv with `Project Requests` somewhere in the name, such as `Savio Project Requests - Project-Requests-2016-2017.csv`.
1. Load the data from `.csv` files into a SQLite database using `import.sh`
1. Use `lookup.sh <account_name>` to get the department data associated with an account. Use `show-jobs-today.sh` to get status of jobs in the past few days.

## Future
This is currently first attempt, and after it is shown to work I'll put more work into cleaning up the data.
- Manually clean up spreadsheets
- Manually clean up the self-reported department (e.g., "MCB" and "Molecular and Cell Biology" mean the same thing)
- Categorize departments into larger domains (e.g., "Biology" or "Mathematics")
