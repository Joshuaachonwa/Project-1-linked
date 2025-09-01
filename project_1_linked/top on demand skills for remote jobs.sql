/* this is to anlyse the top 20 paying skills attached to just remote jobs 
-display skill Id, skill name, average salary, number of jobs attached to the skill and count of postings requiring the skills */

WITH top_paying_jobs AS (
  SELECT
    j.job_id,
    j.job_title,
    j.salary_year_avg,
    CASE 
      WHEN LOWER(j.job_location) = 'anywhere' THEN 'Remote'
      ELSE j.job_location
    END AS job_location
  FROM job_postings_fact j
  WHERE LOWER(j.job_location) = 'anywhere'
    AND j.salary_year_avg IS NOT NULL
    AND (
      LOWER(j.job_title) LIKE '%analyst%'
      OR LOWER(j.job_title) LIKE '%engineer%'
    )
)
SELECT
  sd.skill_id,
  sd.skills AS skill_name,
  tp.job_location,
  AVG(tp.salary_year_avg) AS avg_salary,
  COUNT(sjd.job_id) AS postings_requiring_skill
FROM top_paying_jobs tp
INNER JOIN skills_job_dim sjd
  ON tp.job_id = sjd.job_id
INNER JOIN skills_dim sd
  ON sjd.skill_id = sd.skill_id
GROUP BY sd.skill_id, sd.skills, tp.job_location
ORDER BY postings_requiring_skill DESC
LIMIT 20;