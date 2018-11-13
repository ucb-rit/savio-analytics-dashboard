# Savio Projects
These scripts help map the project account to the department of the project PI so that job/usage data can be correlated with department. Our SLURM database doesn't include department or the email of the PI.

## How it works
1. Download the spreadsheets as `BRC-Projects - All-Projects.csv` and `Savio Project Requests - Project-Requests.csv`
1. Load the data from `.csv` files into a SQLite database using `import.sh`
1. Use `lookup.sh <account_name>` to get the department data associated with an account

`lookup.sh` first looks up the email address of the PI from the `projects` table. It then tries to find the same email address in the `requests` table. The `requests` table also includes the self-reported department, so this is returned.

## Future
- Manually clean up the self-reported department (e.g., "MCB" and "Molecular and Cell Biology" mean the same thing)
- Categorize departments into larger domains (e.g., "Biology" or "Mathematics")
