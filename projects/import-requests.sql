.mode tabs
.import "requests-cleaned.tsv" requests_temp

CREATE TABLE IF NOT EXISTS requests (email TEXT, department TEXT);

INSERT INTO requests (email, department)
    SELECT trim("PI Contact Email Address"), trim("PI's Campus Division or Department")
    FROM requests_temp;

INSERT INTO requests ("Email", "Department")
    SELECT trim("Faculty Contact Email Address"), trim("Faculty's Campus Division or Department")
    FROM requests_temp;

DROP TABLE requests_temp;
