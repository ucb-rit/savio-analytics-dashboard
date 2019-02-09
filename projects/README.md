# Savio Projects
These scripts help map the project account to the department of the project PI so that job/usage data can be correlated with department. Our SLURM database doesn't include department or the email of the PI.

## How it works
1. Download the spreadsheets as `.tsv` files. They should be named as follows:
    - `BRC-Projects - All-Projects.tsv` - For the all projects spreadsheet
    - `*Project Requests*.tsv` - For each year of project requests
    - `Department Name Cleanups - Sheet1.tsv` - For the spreadsheet of clean department names 
1. Load the data from `.tsv` files into a SQLite database using `import.sh`
1. Use `lookup.sh <account_name>` to get the department data associated with an account. Use `show-jobs-today.sh` to get status of jobs in the past few days.

## Future
This is currently a first attempt, and after it is shown to work I'll put more work into cleaning up the data.
- Manually clean up spreadsheets
- Manually clean up the self-reported department (e.g., "MCB" and "Molecular and Cell Biology" mean the same thing)
- Categorize departments into larger domains (e.g., "Biology" or "Mathematics")
