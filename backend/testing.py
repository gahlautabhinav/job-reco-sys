from app_model import recommend_jobs

user = {
    "skills": "python, machine learning, sql",
    "experience": "3 years",
    "work_type": "Full-Time",
    "expected_salary": "90000"
}

print(recommend_jobs(user))