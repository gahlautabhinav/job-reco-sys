import joblib
import os
import re
import pandas as pd

from sklearn.metrics.pairwise import cosine_similarity
from huggingface_hub import hf_hub_download

CACHE_DIR = "/data/models"   # persistent storage in HF Spaces

os.makedirs(CACHE_DIR, exist_ok=True)

REPO_ID = "kaal108/job-reco-tfidf"

print("Downloading models...")

vectorizer_path = hf_hub_download(
    repo_id=REPO_ID,
    filename="vectorizer.pkl",
    cache_dir=CACHE_DIR
)

tfidf_path = hf_hub_download(
    repo_id=REPO_ID,
    filename="tfidf_matrix.pkl",
    cache_dir=CACHE_DIR
)

df_path = hf_hub_download(
    repo_id=REPO_ID,
    filename="jobs_dataframe.pkl",
    cache_dir=CACHE_DIR
)

print("Loading models...")

vectorizer = joblib.load(vectorizer_path)
tfidf_matrix = joblib.load(tfidf_path)
df = joblib.load(df_path)

print("Models loaded")
# ---------------- SALARY ----------------
def salary_in_range(job_salary, expected_salary):
    try:
        numbers = re.findall(r'\d+', job_salary)

        if len(numbers) >= 2:
            low = float(numbers[0]) * 1000
            high = float(numbers[1]) * 1000
            expected = float(expected_salary)

            return low <= expected <= high
    except:
        return False

    return False


# ---------------- MATCH COUNT ----------------
def count_matched_skills(user_skills, job_skills):

    user_skills_list = user_skills.lower().split(',')
    job_skills_text = job_skills.lower()

    count = 0

    for skill in user_skills_list:
        if skill.strip() and skill.strip() in job_skills_text:
            count += 1

    return count


# ---------------- MAIN RECOMMENDER ----------------
def recommend_jobs(user_profile, top_n=5):

    user_text = (
        user_profile.get("skills", "") + " " +
        user_profile.get("skills", "") + " " +
        user_profile.get("experience", "")
    ).lower()

    user_vec = vectorizer.transform([user_text])

    similarity_scores = cosine_similarity(
        user_vec,
        tfidf_matrix
    )[0]

    df['similarity'] = similarity_scores

    results = df.sort_values(
        by='similarity',
        ascending=False
    )

    results = results[results['similarity'] > 0.15]

    results['match_count'] = results['skills'].apply(
        lambda x: count_matched_skills(
            user_profile["skills"], x
        )
    )

    results = results[results['match_count'] >= 2]

    # work type filter
    if user_profile.get("work_type"):

        temp = results[
            results['Work Type']
            .str.lower()
            .str.contains(
                user_profile["work_type"].lower(),
                na=False
            )
        ]

        if not temp.empty:
            results = temp

    # salary filter
    if user_profile.get("expected_salary"):

        temp = results[
            results['Salary Range'].apply(
                lambda x: salary_in_range(
                    str(x),
                    user_profile["expected_salary"]
                )
            )
        ]

        if not temp.empty:
            results = temp

    return results.head(top_n)[[
        "Job Title",
        "Company",
        "Work Type",
        "Salary Range",
        "similarity"
    ]]
