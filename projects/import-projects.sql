.mode tabs
.import "projects-cleaned.tsv" projects_temp
.import "Department Name Cleanups - Sheet1.tsv" name_cleanups

CREATE TABLE IF NOT EXISTS projects (project_name, email);

INSERT INTO projects (project_name, email)
    SELECT trim("3"), trim("Faculty Email")
    FROM projects_temp;

DROP TABLE projects_temp;
