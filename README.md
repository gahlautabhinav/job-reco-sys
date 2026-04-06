# AI Job Recommendation System

An intelligent job recommendation platform that suggests relevant job roles based on a user's **skills and experience**. The system uses a **TF-IDF similarity model** served via a **FastAPI backend** and a **Flutter frontend** for cross-platform user interaction.

The backend is deployed on **Hugging Face Spaces**.

---

## Repository Structure

```
job-reco-sys/
├── backend/          # FastAPI + TF-IDF recommendation engine
└── frontend/         # Flutter cross-platform app
```

---

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                  Flutter Frontend                    │
│        Android · iOS · Web · Desktop                 │
│                                                      │
│   Login ──► Profile ──► Search ──► Saved Jobs       │
└──────────────────────┬──────────────────────────────┘
                       │  POST /recommend
                       ▼
┌─────────────────────────────────────────────────────┐
│           FastAPI Backend  (Hugging Face)            │
│                                                      │
│   TF-IDF Vectorizer  ──►  Cosine Similarity         │
│   1.6 M job listings                                 │
│   https://kaal108-job-reco-api.hf.space              │
└─────────────────────────────────────────────────────┘
```

---

## Live Links

| Resource     | URL |
|--------------|-----|
| Backend API  | https://kaal108-job-reco-api.hf.space |
| API Docs     | https://kaal108-job-reco-api.hf.space/docs |

---

## Backend

### Tech Stack

- **Python** · **FastAPI** · **Uvicorn**
- **Scikit-learn** — TF-IDF Vectorizer + Cosine Similarity
- **Docker** for containerization
- Deployed on **Hugging Face Spaces**

### Model Details

| Property | Value |
|----------|-------|
| Dataset  | 1.6 million job listings |
| Algorithm | TF-IDF + Cosine Similarity |
| Features used | skills, job title, role, description, responsibilities, qualifications, experience |
| Artifacts | `vectorizer.pkl`, `tfidf_matrix.pkl`, `jobs_dataframe.pkl` |

### API Reference

#### `POST /recommend`

**Request body:**

```json
{
  "skills": "python, machine learning, sql",
  "experience": "3 years",
  "work_type": "Full-Time",
  "expected_salary": "90000",
  "top_n": 5
}
```

| Field             | Type   | Required | Description |
|-------------------|--------|----------|-------------|
| `skills`          | string | Yes      | Comma-separated skills |
| `experience`      | string | Yes      | Experience description |
| `work_type`       | string | No       | `Full-Time` / `Part-Time` / `Contract` |
| `expected_salary` | string | No       | Expected salary as a number string |
| `top_n`           | int    | No       | Number of results (default: 5) |

**Response:**

```json
[
  {
    "Job Title": "Data Scientist",
    "Work Type": "Full-Time",
    "Salary Range": "$61K–$122K",
    "similarity": 0.572
  }
]
```

> `similarity` is a score 0–1. Multiply by 100 to get the match percentage.

### Local Setup

```bash
cd backend
pip install -r requirements.txt
uvicorn app:app --reload
```

---

## Frontend

### Tech Stack

- **Flutter** (Dart) — Android, iOS, Web, Desktop
- **Provider** — state management
- **sqflite** — local SQLite persistence (session + saved jobs)
- **http** — REST API calls
- Aurora gradient UI with frosted-glass cards

### Features

| Screen | Description |
|--------|-------------|
| **Login** | Auth gate with session persistence across restarts |
| **Search** | Enter skills + experience → AI-powered job recommendations |
| **Job Card** | Job title, work type, salary range, match % badge |
| **Saved Jobs** | Bookmark and revisit recommendations |
| **Profile** | Set preferred work type, expected salary, top-N result count |

### App Flow

```
Login
  └──► Profile Setup
           └──► Search (skills + experience)
                    └──► Job Recommendations
                              ├── Save Job  ──► Saved Jobs tab
                              └── Match %  (similarity × 100)
```

### Local Setup

```bash
cd frontend
flutter pub get
flutter run                 # runs on connected device
flutter run -d chrome       # web
flutter run -d android      # Android emulator / device
```

> **Cold start note:** The Hugging Face container may take 2–5 s on the first request. Subsequent requests are under 500 ms. The app fires a warm-up ping automatically on launch when a profile is configured.

### Project Structure

```
frontend/
├── lib/
│   ├── core/
│   │   ├── constants/       # App colors, text styles
│   │   └── theme/           # AppTheme
│   ├── data/
│   │   ├── models/          # JobRecommendation, UserProfile
│   │   ├── repositories/    # AuthRepository, JobRepository, ProfileRepository
│   │   └── services/        # ApiService (HTTP), DatabaseService (SQLite)
│   ├── providers/           # AuthProvider, SearchProvider, SavedJobsProvider, ProfileProvider
│   ├── screens/
│   │   ├── auth/            # LoginScreen
│   │   ├── search/          # SearchScreen + JobCard, SearchInputForm, etc.
│   │   ├── saved/           # SavedScreen + SavedJobCard
│   │   └── profile/         # ProfileScreen + PreferenceChipRow
│   └── shared/
│       ├── transitions/     # SlideFadeRoute
│       └── widgets/         # AuroraBackground, FrostedCard, GradientButton, MatchBadge, SkillChip, BottomNavBar
├── pubspec.yaml
└── test/
```

---

## Performance

| Scenario | Latency |
|----------|---------|
| First request (cold start) | 2–5 s |
| Subsequent requests | < 500 ms |

---

## Future Improvements

- Semantic embeddings (BERT / sentence-transformers)
- Location-based filtering
- Resume upload & parsing
- Pagination for large result sets
- Push notifications for new matching jobs

---

## License

MIT License
