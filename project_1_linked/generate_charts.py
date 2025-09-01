import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path

# === Paths ===
assets_dir = Path("assets")
assets_dir.mkdir(exist_ok=True)

# === Load CSVs ===
posting_count = pd.read_csv("job posting count .csv")
top_paying_jobs = pd.read_csv("top paying jobs.csv")
remote_skills = pd.read_csv("top paying remote skills .csv")
top_skills = pd.read_csv("top paying skills .csv")
jobs_with_skills = pd.read_csv("top paying jobs in 2023 with skills .csv")

# === Salary distribution by location ===
df = top_paying_jobs.copy()
df["job_location"] = df["job_location"].replace({"Anywhere": "Remote"})
plt.figure()
df.boxplot(column="salary_year_avg", by="job_location")
plt.title("Top 50 roles: salary distribution by location")
plt.suptitle("")
plt.xlabel("Location")
plt.ylabel("Salary (USD)")
plt.tight_layout()
plt.savefig(assets_dir / "salary_box_by_location.png")
plt.close()

# === Role mix (Analyst vs Engineer) ===
df["role_type"] = np.where(df["job_title"].str.lower().str.contains("analyst"), "Analyst", "Engineer")
counts = df.groupby(["job_location","role_type"]).size().unstack(fill_value=0)
counts.plot(kind="bar")
plt.title("Top 50 roles: Analyst vs Engineer by location")
plt.xlabel("Location")
plt.ylabel("Count")
plt.tight_layout()
plt.savefig(assets_dir / "role_mix_by_location.png")
plt.close()

# === Remote skills: demand vs salary ===
plt.figure()
plt.scatter(remote_skills["postings_requiring_skill"], remote_skills["avg_salary"])
top10 = remote_skills.nlargest(10, "postings_requiring_skill")
for _, r in top10.iterrows():
    plt.annotate(r["skill_name"], (r["postings_requiring_skill"], r["avg_salary"]))
plt.title("Remote skills: demand vs salary")
plt.xlabel("Postings requiring skill")
plt.ylabel("Average salary (USD)")
plt.tight_layout()
plt.savefig(assets_dir / "remote_skills_demand_vs_salary.png")
plt.close()

# === Most repeated postings ===
top_posts = posting_count.groupby(["job_title","job_location"])["job_posting_count"].sum().reset_index()
top_posts = top_posts.sort_values("job_posting_count", ascending=False).head(10)
labels = top_posts["job_title"] + " • " + top_posts["job_location"]
plt.barh(labels, top_posts["job_posting_count"])
plt.title("Most repeated postings")
plt.xlabel("Postings")
plt.tight_layout()
plt.savefig(assets_dir / "most_repeated_postings.png")
plt.close()

# === Company presence in Top-50 ===
company_counts = df["company_name"].value_counts().head(10)
plt.barh(company_counts.index, company_counts.values)
plt.title("Top companies in Top-50")
plt.xlabel("Appearances")
plt.tight_layout()
plt.savefig(assets_dir / "top_companies_in_top50.png")
plt.close()

# === Top paying skills by location ===
for loc in top_skills["location"].unique():
    loc_df = top_skills[top_skills["location"] == loc].sort_values("avg_salary", ascending=True).head(15)
    plt.barh(loc_df["skill_name"], loc_df["avg_salary"])
    plt.title(f"Top paying skills – {loc}")
    plt.xlabel("Average salary (USD)")
    plt.tight_layout()
    fname = f"top_paying_skills_{loc.replace(' ','_').lower()}.png"
    plt.savefig(assets_dir / fname)
    plt.close()

# === Skills frequency in Top-50 jobs ===
skill_freq = jobs_with_skills.groupby("skills")["job_id"].count().reset_index().sort_values("job_id", ascending=False).head(15)
plt.barh(skill_freq["skills"], skill_freq["job_id"])
plt.title("Skills frequency in Top-50 jobs")
plt.xlabel("Appearances")
plt.tight_layout()
plt.savefig(assets_dir / "skills_frequency_top50.png")
plt.close()

print("✅ All charts generated in the 'assets' folder!")

