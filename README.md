# ✈️ Flight Delay Estimator Frontend

[![Flutter](https://img.shields.io/badge/Flutter-3.41.2%2B-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11.0%2B-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Material Design 3](https://img.shields.io/badge/Design-Material%203-7F3DEC?logo=materialdesign&logoColor=white)](https://m3.material.io)
[![State Management](https://img.shields.io/badge/State-Riverpod-00C4B4?logo=riverpod&logoColor=white)](https://riverpod.dev)

An elegant, modern, and highly responsive **Material Design 3** mobile and web application built with Flutter. It leverages an XGBoost machine learning model from the FastAPI backend to forecast flight delays based on weather metrics and flight parameters.

---

## ✨ Features

- **🧠 XGBoost AI Predictions**: Inputs flight parameters (Airline, movement type) and 13 distinct weather metrics to generate instant delay forecasts.
- **⚡ Dynamic Connection Utility**: Change backend API endpoints on the fly within the settings panel, backed by a **"Test Connection"** checker (`/api/health`).
- **🌦️ Weather Presets (Templates)**: Single-tap quick presets (e.g. *Clear Sky, Heavy Rain, Windy Storm, Moderate Weather*) that automatically populate all 13 weather parameters with realistic, pre-validated data.
- **🔄 Modern State Management**: Built using **Riverpod** with a reactive `StateNotifier` flow to guarantee predictable state changes and separation of concerns.
- **💾 Persistent Search History**: Local persistence using `SharedPreferences` to log past predictions, featuring swipe-to-delete actions and expanding/collapsing details.
- **🌓 Adaptive Theme**: Sleek dark and light modes styled around Material 3 dynamic color guidelines.
- **🏗️ Clean Architecture (MVVM)**: Highly decoupled design with clear divisions between views, viewmodels, models, services, and widgets.

---

## 🛠️ Tech Stack & Packages

Here are the main libraries driving this application:

| Package | Version | Purpose |
| :--- | :--- | :--- |
| **`flutter_riverpod`** | `^3.3.2` | Clean, compile-safe state management & DI |
| **`dio`** | `^5.4.3` | Robust HTTP client featuring custom timeouts & interceptors |
| **`go_router`** | `^17.3.0` | Declarative, URL-driven routing schema for mobile & web |
| **`shared_preferences`** | `^2.2.3` | Fast key-value local persistent storage |
| **`google_fonts`** | `^8.1.0` | Premium typography integrations |
| **`lottie`** | `^3.1.2` | High-fidelity vectors and fluid motion graphics |

---

## 📂 Project Directory Structure

```text
lib/
├── core/
│   ├── services/
│   │   ├── api_service.dart      # Dio network client with timeout & validation mapping
│   │   ├── storage_service.dart  # Local preferences & history persistence
│   │   └── router.dart           # GoRouter route declarations
│   └── theme/
│       └── theme.dart            # Light and Dark Material 3 theme setups
├── models/
│   ├── prediction_request.dart   # Dart representation of prediction features
│   ├── prediction_response.dart  # Model mapping probability & confidence classes
│   └── history_item.dart         # Wrapper for request/response logs
├── viewmodels/
│   ├── settings_viewmodel.dart   # Riverpod notifier for URL/Theme preferences
│   └── prediction_viewmodel.dart # State management for queries, presets & logs
├── views/
│   ├── splash/
│   │   └── splash_view.dart      # Launch splash screen with animations
│   ├── home/
│   │   └── home_view.dart        # Stats dashboard & landing panel
│   ├── prediction/
│   │   └── prediction_view.dart  # Input form with weather preset quick chips
│   ├── result/
│   │   └── result_view.dart      # Outcome page with probability gauge & copying
│   ├── history/
│   │   └── history_view.dart     # Locally stored search log list
│   └── settings/
│       └── settings_view.dart    # Theme selector & endpoint testing utility
└── widgets/
    ├── custom_textfield.dart     # Custom inputs with validation rules
    ├── custom_dropdown.dart      # Custom styling for dropdown form fields
    ├── custom_button.dart        # Flat actions supporting loading/disabled states
    ├── loading_dialog.dart       # Modal spinner for asynchronous POST triggers
    └── prediction_card.dart      # Styled card component displaying history items
```

---

## 🚀 Setup & Running

### Prerequisites
- **Flutter SDK**: `3.41.2` or later
- **Dart SDK**: `3.11.0` or later

### 1. Fetch Dependencies
Navigate to the `frontend/` directory and pull packages:
```bash
flutter pub get
```

### 2. Configure Backend endpoint
The app is configured by default to target `http://10.0.2.2:8000` (the loopback address for the Android Emulator to access the host machine's localhost).

To update the endpoint:
1. Open the app and go to **Settings** (gear icon in the top right of the dashboard).
2. Enter your custom backend IP or URL (e.g., `http://localhost:8000` for web/desktop, or your local network IP).
3. Click **Test Connection** to execute a ping check.
4. Click **Save URL** to persist the configuration.

### 3. Run the Application

#### Run on Chrome / Web (or Default Device)
```bash
flutter run
```

#### Run specifically on Web using WASM
```bash
flutter run -d edge --wasm
# OR
flutter run -d chrome --wasm
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
  - `settingsProvider`: Exposes user options (theme preference, target API URL) and triggers backend connectivity verification.
  - `predictionProvider`: Manages the API submission process, stores current prediction configurations, and maintains the persistent history list.
