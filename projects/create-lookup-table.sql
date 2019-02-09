CREATE TABLE IF NOT EXISTS lookup AS 
    SELECT 
        DISTINCT projects.project_name AS project, 
        projects.email AS email, 
        name_cleanups."Clean Department Name" AS department 
    FROM projects, requests, name_cleanups
    WHERE 
        projects.email = requests.email AND
        requests.department = name_cleanups."Entered Name"
    UNION
    SELECT
        DISTINCT projects.project_name AS project,
        projects.email AS email,
        requests.department AS department
    FROM projects, requests
    WHERE
        projects.email = requests.email AND
        NOT EXISTS (
            SELECT "Clean Department Name"
            FROM name_cleanups
            WHERE requests.department = name_cleanups."Entered Name"
        );
CREATE INDEX IF NOT EXISTS lookup_project ON lookup (project);
