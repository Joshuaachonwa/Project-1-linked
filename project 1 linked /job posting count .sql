/*coutn of most occuring job postings*/
SELECT
  j.job_title,
  c.name AS company_name,
  j.job_location,
  COUNT(j.job_id) AS job_posting_count,
  COUNT(DISTINCT sjd.skill_id) AS num_skills_required
FROM job_postings_fact j
JOIN company_dim c
  ON j.company_id = c.company_id
LEFT JOIN skills_job_dim sjd
  ON j.job_id = sjd.job_id
WHERE
  LOWER(j.job_location) IN ('anywhere', 'united states', 'united kingdom', 'canada')
  AND (
    LOWER(j.job_title) LIKE '%analyst%'
    OR LOWER(j.job_title) LIKE '%engineer%'
  )
GROUP BY j.job_title, c.name, j.job_location
ORDER BY job_posting_count DESC, num_skills_required DESC
LIMIT 50;