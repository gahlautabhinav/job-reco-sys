# 🎯 AI Job Recommendation System

An intelligent job recommendation platform that suggests relevant job roles based on a user's **skills and experience**. The system uses a **TF-IDF similarity model** served via **FastAPI backend** and a **Flutter frontend** for user interaction.

The app is deployed using **Hugging Face Spaces**.

---

# 🌐 Live Application

Frontend App

```
It is an apk file.
```

Backend API

```
https://kaal108-job-reco-api.hf.space
```

API Docs

```
https://kaal108-job-reco-api.hf.space/docs
```

---

# 🧠 How It Works

The system follows this pipeline:

```
User Input (Skills + Experience)
            ↓
Flutter Frontend
            ↓
FastAPI Backend (HuggingFace Spaces)
            ↓
TF-IDF Recommendation Model
            ↓
Similarity Matching
            ↓
Top Job Recommendations
            ↓
Displayed in Flutter UI
```

---

# ✨ Features

### 🎯 Smart Job Recommendations

* Skill-based matching
* Experience-aware ranking
* High relevance scoring

### ⚡ Fast API Backend

* FastAPI
* HuggingFace Spaces deployment
* Cached model loading

### 📱 Flutter Frontend

* Clean UI
* Real-time recommendations
* Responsive design

### 🔍 Filtering Support

* Work type filter
* Salary filter
* Top N recommendations

---

# 📸 App Flow

### 1. User enters skills

Example:

```
python, machine learning, sql
```

### 2. User enters experience

```
3 years
```

### 3. System returns recommendations

Example:

```
Data Scientist
Full-Time
Salary: $61K-$122K
Match: 57%
```

---

# 🏗️ Architecture

```
Flutter App (Frontend)
        ↓
FastAPI (Backend)
        ↓
TF-IDF Model
        ↓
Job Dataset (1.6M records)
```

---

# 🔧 Tech Stack

## Frontend

* Flutter
* Dart
* HTTP API integration

## Backend

* FastAPI
* Python
* Uvicorn

## Machine Learning

* Scikit-learn
* TF-IDF Vectorizer
* Cosine Similarity

## Deployment

* Hugging Face Spaces (Frontend)
* Hugging Face Spaces (Backend)
* Hugging Face Model Hub

---

# 📡 API Endpoint

POST `/recommend`

### Request

```json
{
  "skills": "python, machine learning, sql",
  "experience": "3 years"
}
```

Optional:

```json
{
  "skills": "python, machine learning, sql",
  "experience": "3 years",
  "work_type": "Full-Time",
  "expected_salary": "90000",
  "top_n": 5
}
```

---

# 📤 Response

```json
[
  {
    "Job Title": "Data Scientist",
    "Work Type": "Full-Time",
    "Salary Range": "$61K-$122K",
    "similarity": 0.57
  }
]
```

---

# 📊 Match Score

```
match % = similarity × 100
```

Example:

```
0.57 → 57% match
```

---

# 📁 Project Structure

```
job-reco-app
│
├── frontend (Flutter)
│
├── backend (FastAPI)
│   ├── app.py
│   ├── app_model.py
│   └── requirements.txt
│
└── model (HuggingFace)
    ├── vectorizer.pkl
    ├── tfidf_matrix.pkl
    └── jobs_dataframe.pkl
```

---

# 🚀 Running Locally

## Backend

```bash
pip install -r requirements.txt
python -m uvicorn app:app --reload
```

---

## Frontend

```bash
flutter pub get
flutter run
```

---

# 📦 Model Details

Dataset size:

```
1.6 million job listings
```

Model type:

```
TF-IDF + Cosine Similarity
```

Features used:

* skills
* job title
* role
* description
* responsibilities
* qualifications
* experience

---

# ⚡ Performance

* First load: model download
* Subsequent calls: < 500ms
* Cached in HuggingFace Spaces

---

# 🎯 Future Improvements

* Semantic embeddings (BERT)
* Location-based recommendations
* Personalized recommendations
* Resume upload
* Job bookmarking
* Pagination support

---

# 📄 License

MIT License
