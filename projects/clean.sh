#!/bin/bash


clean () {
  echo "$3" > "$2"
  cat "$1" | tail -n +2 >> "$2"
}

# Clean BRC Projects
PROJECTS_ORIGINAL_FILE="BRC-Projects - All-Projects.csv"
PROJECTS_CLEANED_FILE="projects-cleaned.csv"
PROJECTS_HEADER="Contact Name,Empty1,Project Name,Main Contacts Name,Main Contacts Email,Faculty Name,Faculty Email,Number,Empty2,Empty3,Empty4,Empty5,Empty6,Empty7,Empty8,Empty9"
clean "$PROJECTS_ORIGINAL_FILE" "$PROJECTS_CLEANED_FILE" "$PROJECTS_HEADER"

# Clean BRC Project Requests
REQUESTS_ORIGINAL_FILE="All-Project-Requests.csv"
REQUESTS_CLEANED_FILE="requests-cleaned.csv"
REQUESTS_HEADER='Timestamp,Email Address,,"PI Name (First, Middle, Last)",PI'"'"'s Campus Division or Department,PI Contact Email address,PI Phone number,Does the project'"'"'s PI require an account on the cluster?,a)     A single word name to identify your project,b)  Scope and intent of research needing computation,c)  Computational aspects of the research,"d) Existing computing resources (outside of SAVIO) currently being used by this project. If you use cloud computing resources, we would be interested in hearing about it.",e) Which of the following best describes your need for this system:,"a) How many processor cores does your application use?  (min, max, typical runs)",b) How much memory per core does your typical job require?,c) What is the run time of your typical job?,d) Estimate how many processor-core-hrs your research will need over the year.,e) BRC has 4 512GB large memory nodes. What is your expected use of these nodes?,f) Data Storage Space,g) Describe your applications I/O requirements,h) Interconnect performance,i) Network connection from SAVIO to the Internet,"j) Many-core, Intel Phi or Nvidia GPU",k) Cloud computing,a)   What is the source of the software you use (or would use)?,"b) Does your application require access to an outside web server or database? If yes, please explain."'
rm $REQUESTS_ORIGINAL_FILE
for FILE in *Project\ Requests*.csv; do
  tail -n +2 "$FILE" >> $REQUESTS_ORIGINAL_FILE
done
clean "$REQUESTS_ORIGINAL_FILE" "$REQUESTS_CLEANED_FILE" "$REQUESTS_HEADER"
