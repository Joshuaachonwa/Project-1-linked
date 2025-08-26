/* 
Question: What are the top-paying analyst and engineering jobs?
-   Identify the top 50 highest-paying Analyst and Engineering roles that are available remotely in the uk, US and Canada.
-   Focuses on job postings with specified salaries (remove nulls).
-   Why? Highlight the top-paying opportunities for Analysts and Engineering, offering insights into the most optimal roles and skilss
*/

SELECT
  c.name AS company_name,
  j.job_id,
  j.job_title,
  CASE 
    WHEN LOWER(j.job_location) = 'anywhere' THEN 'Remote'
    ELSE j.job_location
  END AS job_location,
  j.job_schedule_type,
  j.salary_year_avg,
  j.job_posted_date
FROM job_postings_fact j
JOIN company_dim c
  ON j.company_id = c.company_id
WHERE
  j.salary_year_avg IS NOT NULL
  AND LOWER(j.job_location) IN ('anywhere', 'united kingdom', 'united states', 'canada')
  AND (
    LOWER(j.job_title) LIKE '%analyst%'
    OR LOWER(j.job_title) LIKE '%engineer%'
  )
ORDER BY j.salary_year_avg DESC
LIMIT 50;