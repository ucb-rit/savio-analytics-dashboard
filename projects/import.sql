.mode csv
.import "projects-cleaned.csv" projects
.import "requests-cleaned.csv" requests
CREATE INDEX IF NOT EXISTS projects_name ON projects ("Project Name");
CREATE INDEX IF NOT EXISTS requests_email ON requests ("PI Contact Email Address");
CREATE TABLE IF NOT EXISTS lookup AS SELECT DISTINCT projects."Project Name" AS project, projects."Faculty Email" AS email, requests."PI's Campus Division or Department" AS department FROM projects, requests WHERE projects."Faculty Email" = requests."PI Contact Email Address";
CREATE INDEX IF NOT EXISTS lookup_project ON lookup (project);

