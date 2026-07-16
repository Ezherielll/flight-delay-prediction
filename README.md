# ✈️ Flight Delay Estimator Frontend

[![Flutter](https://img.shields.io/badge/Flutter-3.41.2%2B-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11.0%2B-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Material Design 3](https://img.shields.io/badge/Design-Material%203-7F3DEC?logo=materialdesign&logoColor=white)](https://m3.material.io)
[![State Management](https://img.shields.io/badge/State-Riverpod-00C4B4?logo=riverpod&logoColor=white)](https://riverpod.dev)
[![Backend](https://img.shields.io/badge/Backend-Serverpod%203.4.11-FF6B6B?logo=dart&logoColor=white)](https://serverpod.dev)

An elegant, modern, and highly responsive **Material Design 3** mobile and web application built with Flutter. It utilizes a **dual-backend architecture**:
- **Python/FastAPI** server for XGBoost machine learning inference.
- **Serverpod (Dart)** server backed by PostgreSQL for secure email authentication, user management, and cloud history syncing.

---

## ✨ Features

- **🔐 Secure User Authentication**: Built-in email & password signup and signin, featuring inline OTP verification code screens.
- **🧠 XGBoost AI Predictions**: Inputs flight parameters (Airline, movement type) and 13 distinct weather metrics to generate instant delay forecasts via FastAPI.
- **☁️ Cloud Persistent History**: Automatically syncs past delay predictions to a secure cloud database (PostgreSQL via Serverpod), replacing simple local storage.
- **⚡ Dynamic Connection Utility**: Change FastAPI ML endpoint on the fly within the settings panel, backed by a **"Test Connection"** checker (`/api/health`).
- **🌦️ Weather Presets (Templates)**: Single-tap quick presets (e.g. *Clear Sky, Heavy Rain, Windy Storm, Moderate Weather*) that automatically populate all 13 weather parameters with realistic, pre-validated data.
- **🔄 Modern State Management**: Built using **Riverpod** notifier flow to guarantee predictable state changes and separation of concerns.
- **🌓 Adaptive Theme**: Sleek dark and light modes styled around Material 3 dynamic color guidelines.
- **👥 Role-Based Access Control (RBAC)**: Restricts and structures access based on two user roles (Administrator & Petugas AMC) with server-side checking and GoRouter guards.
- **🏗️ Clean Architecture (MVVM)**: Highly decoupled design with clear divisions between views, viewmodels, models, services, and widgets.

---

## 🛠️ Tech Stack & Packages

Here are the main libraries driving this application:

| Package | Version | Purpose |
| :--- | :--- | :--- |
| **`flutter_riverpod`** | `^3.3.2` | Clean, compile-safe state management & DI |
| **`serverpod_flutter`** | `3.4.11` | Serverpod client connector for database sync |
| **`serverpod_auth_shared_flutter`** | `3.4.11` | Serverpod session manager core |
| **`serverpod_auth_email_flutter`** | `3.4.11` | Email and password authentication handler |
| **`dio`** | `^5.4.3` | Robust HTTP client featuring custom timeouts & interceptors |
| **`go_router`** | `^17.3.0` | Declarative, URL-driven routing schema for mobile & web |
| **`google_fonts`** | `^8.1.0` | Premium typography integrations |
| **`lottie`** | `^3.1.2` | High-fidelity vectors and fluid motion graphics |

---

## 📂 Project Directory Structure

```text
lib/
├── core/
│   ├── services/
│   │   ├── api_service.dart      # Dio network client for ML backend
│   │   ├── serverpod_client.dart # Serverpod client and session manager provider
│   │   ├── auth_service.dart     # Service layer for login/signup controller
│   │   ├── storage_service.dart  # Local preferences persistence
│   │   └── router.dart           # GoRouter route declarations with auth redirect guard
│   └── theme/
│       └── theme.dart            # Light and Dark Material 3 theme setups
├── models/
│   ├── prediction_request.dart   # Dart representation of prediction features
│   ├── prediction_response.dart  # Model mapping probability & confidence classes
│   ├── history_item.dart         # Wrapper for request/response logs
│   └── user_role.dart            # UserRole enum and parser
├── viewmodels/
│   ├── settings_viewmodel.dart   # Riverpod notifier for URL/Theme preferences
│   ├── prediction_viewmodel.dart # State management for queries, presets & Serverpod history
│   ├── auth_viewmodel.dart       # Riverpod notifier for user session state & role info
│   └── admin_viewmodel.dart      # Admin dashboard actions (users, roles)
├── views/
│   ├── splash/
│   │   └── splash_view.dart      # Launch splash screen with animations
│   ├── auth/
│   │   ├── login_view.dart       # Glassmorphic Email Login form screen
│   │   └── register_view.dart    # User registration with inline OTP input
│   ├── admin/
│   │   └── admin_panel_view.dart # Tabbed panel for user roles & all prediction logs
│   ├── home/
│   │   └── home_view.dart        # Stats dashboard & landing panel
│   ├── prediction/
│   │   └── prediction_view.dart  # Input form with weather preset quick chips
│   ├── result/
│   │   └── result_view.dart      # Outcome page with probability gauge & copying
│   ├── history/
│   │   └── history_view.dart     # Serverpod cloud-stored search log list
│   └── settings/
│       └── settings_view.dart    # Theme selector & endpoint testing utility
└── widgets/
    ├── custom_textfield.dart     # Custom inputs with validation rules
    ├── custom_dropdown.dart      # Custom styling for dropdown form fields
    ├── custom_button.dart        # Flat actions supporting loading/disabled states
    ├── loading_dialog.dart       # Modal spinner for asynchronous POST triggers
    ├── prediction_card.dart      # Styled card component displaying history items
    └── app_drawer.dart           # Navigation drawer featuring user info & log out
```

---

## 🚀 Setup & Running

### Prerequisites
- **Flutter SDK**: `3.41.2` or later
- **Dart SDK**: `3.11.0` or later
- **Docker Desktop**: For running PostgreSQL database container
- **Serverpod CLI**: Activate via `dart pub global activate serverpod_cli 3.4.11`

### 1. Run Serverpod Backend
Navigate to the `flight_server` directory (sibling to `frontend`):
```bash
cd ../flight_server

# 1. Start PostgreSQL & Redis databases
docker compose up -d

# 2. Generate and apply database migrations (if models change, e.g. user_role)
serverpod create-migration
dart bin/main.dart --apply-migrations

# 3. Start Serverpod server
dart bin/main.dart
```

### 2. Fetch Frontend Dependencies
Navigate to the `frontend/` directory and pull packages:
```bash
cd ../frontend
flutter pub get
```

### 3. Run the Application

#### Run on Web/Desktop/Mobile (Default Device)
```bash
flutter run
```

#### Run in Release Mode
```bash
flutter run --release
```

---

## 🏛️ Architecture & Clean Code

- **Null Safety**: 100% sound null safety.
- **MVVM Pattern**:
  - **Models**: Plain Dart classes mapping API JSON payloads.
  - **Views**: UI layouts. They listen to provider states and display widgets accordingly.
  - **ViewModels**: Manage business logic and asynchronous tasks, completely decoupled from UI code.
- **Riverpod State Flow**:
  - `authProvider`: Manages user authentication state, handles session login/logout, and listens to the local Serverpod `SessionManager` + user role updates.
  - `settingsProvider`: Exposes user options (theme preference, target API URL) and triggers FastAPI connectivity verification.
  - `predictionProvider`: Manages the API submission process, stores current prediction configurations, and maintains the database history list.
  - `adminProvider`: Handles administrative data management including list of registered user roles and all system predictions.
