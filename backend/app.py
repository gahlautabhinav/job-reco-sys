from fastapi import FastAPI
from pydantic import BaseModel
from typing import Optional

from app_model import recommend_jobs

app = FastAPI()


# ---------------- REQUEST MODEL ----------------
class UserProfile(BaseModel):
    skills: str
    experience: str
    work_type: Optional[str] = None
    expected_salary: Optional[str] = None
    top_n: Optional[int] = 5


# ---------------- HEALTH CHECK ----------------
@app.get("/")
def home():
    return {"message": "Job Recommender API Running"}


# ---------------- RECOMMEND API ----------------
@app.post("/recommend")
def recommend(profile: UserProfile):

    user_data = {
        "skills": profile.skills,
        "experience": profile.experience,
        "work_type": profile.work_type,
        "expected_salary": profile.expected_salary
    }

    results = recommend_jobs(
        user_data,
        top_n=profile.top_n
    )

    return results.to_dict(orient="records")