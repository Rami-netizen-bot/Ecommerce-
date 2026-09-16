# E-Commerce Mobile Application & Backend

A full-stack mobile e-commerce application developed as a university final project for Mobile Application 2. The project features a high-performance **FastAPI (Python)** backend utilizing SQLAlchemy and an asynchronous-ready architecture, paired with a modern **Flutter** frontend powered by **GetX** for reactive state management and clean modular routing.

---

## Tech Stack

* **Frontend:** Flutter, GetX, Dio
* **Backend:** FastAPI, Python, SQLAlchemy, Pydantic
* **Database:** SQLite (Development)

---

## Project Architecture & Directory Structure

```text
ecommerce_project/
│
├── ecommerce_backend/          # FastAPI Python Server
│   ├── app/
│   │   ├── database.py         # SQLAlchemy engine and session setup
│   │   ├── models.py           # Database ORM models (Users, Products, Orders)
│   │   └── schemas.py          # Pydantic data validation schemas
│   ├── main.py                 # Application entry point and API endpoints
│   └── requirements.txt        # Python package dependencies
│
└── ecommerce_app/              # Flutter Mobile Client
    ├── lib/
    │   ├── data/               # API providers and models
    │   ├── modules/            # Feature-based architecture (Auth, Shop, Cart)
    │   ├── routes/             # GetX navigation and page mappings
    │   └── themes/             # App typography and light/dark color schemes
    └── pubspec.yaml            # Flutter package dependencies
```

---

## Getting Started & Installation

### 1. Backend Setup (FastAPI)

Navigate to your backend directory and set up a Python virtual environment:

```bash
cd ecommerce_backend
python -m venv venv
```

Activate the virtual environment:
* **Windows (Command Prompt):** `venv\Scripts\activate`
* **Windows (PowerShell):** `venv\Scripts\Activate.ps1`
* **macOS / Linux:** `source venv/bin/activate`

Install dependencies and run the server:

```bash
pip install fastapi uvicorn sqlalchemy pydantic
uvicorn main:app --reload
```

* The API will be available at `http://127.0.0.1:8000`.
* Automated Swagger documentation can be accessed at `http://127.0.0.1:8000/docs`.

### 2. Frontend Setup (Flutter + GetX)

Open a new terminal window, navigate to your Flutter project directory, and install the required packages:

```bash
cd ecommerce_app
flutter pub add get dio
```

Run the application on your Android emulator or physical device:

```bash
flutter run
```
*(Note: When running on an Android Emulator, use `http://10.0.2.2:8000` to communicate with your local FastAPI server).*

---

## Core API Endpoints

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| **GET** | `/` | Root verification check |
| **GET** | `/products/` | Retrieve product catalog (supports category filtering) |
| **POST** | `/products/` | Add a new product to the database |





