/* we want to get the top 20 paying skills in line with the average salary for remote jobs, united state, united kingdom and canada
-display skill Id, skill name, average salary, number of jobs attached to the skill and count of postings requiring the skills */

SELECT
  sd.skill_id,
  sd.skills AS skill_name,
  j.job_location AS location,
  AVG(j.salary_year_avg) AS avg_salary,
  COUNT(DISTINCT j.job_id) AS num_jobs,
  COUNT(sjd.job_id) AS postings_requiring_skill
FROM job_postings_fact j
INNER JOIN skills_job_dim sjd
  ON j.job_id = sjd.job_id
INNER JOIN skills_dim sd
  ON sjd.skill_id = sd.skill_id
WHERE
  j.salary_year_avg IS NOT NULL
  AND LOWER(j.job_location) IN ('anywhere', 'united states', 'united kingdom', 'canada')
  AND (
    LOWER(j.job_title) LIKE '%analyst%'
    OR LOWER(j.job_title) LIKE '%engineer%'
  )
GROUP BY sd.skill_id, sd.skills, j.job_location
ORDER BY avg_salary DESC
LIMIT 20;