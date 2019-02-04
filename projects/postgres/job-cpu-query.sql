-- TODO: Not yet enough data to test
SELECT cpu.timestamp, cpu.host, cpu.usage_user FROM cpu, job_nodes, jobs
    WHERE jobs.job_id = job_nodes.job_id
        AND cpu.timestamp >= jobs.start_time
        AND cpu.timestamp <= jobs.end_time
        AND cpu.host = job_nodes.hostname
        AND jobs.job_id = $JOB_ID; 
