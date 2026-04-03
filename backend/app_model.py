import joblib
import pandas as pd
import re
import os

from sklearn.metrics.pairwise import cosine_similarity

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

MODEL_DIR = os.path.join(BASE_DIR, "models")

print("Loading saved model...")

vectorizer = joblib.load(
    os.path.join(MODEL_DIR, "vectorizer.pkl")
)

tfidf_matrix = joblib.load(
    os.path.join(MODEL_DIR, "tfidf_matrix.pkl")
)

df = joblib.load(
    os.path.join(MODEL_DIR, "jobs_dataframe.pkl")
)

print("Model loaded successfully")


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