<<<<<<< HEAD
# flight-delay-prediction
=======
# Flight Delay Estimator Frontend

An elegant, modern, and highly responsive Material Design 3 Flutter application that predicts flight delays using an XGBoost machine learning model. This app integrates with the FastAPI Weather & Flight Delay Prediction backend.

---

## 🚀 Features

- **XGBoost AI Predictions**: Inputs flight parameters (Airline, movement, type) and local weather metrics to forecast delays.
- **Dynamic API Settings**: Edit the backend host IP or URL directly inside the app settings with an integrated **"Test Connection"** utility (pings the health check endpoint `/api/health`).
- **Weather Templates (Presets)**: Tapping quick presets (e.g. *Clear Sky, Heavy Rain, Windy Storm, Moderate Weather*) automatically populates all 13 weather inputs with realistic, pre-validated parameters.
- **State Management**: Built on **Riverpod** (`flutter_riverpod`) using `StateNotifier` for predictable, reactive UI updates.
- **Persistent Local History**: Stores past predictions using `SharedPreferences`, supporting detailed item expansion and swipe-to-delete.
- **Dark Mode**: Fully supports dual light and dark themes with adaptive coloring and typography.
- **Clean Architecture (MVVM)**: Segregated layers (Model, View, ViewModel, Services) for high maintainability.

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

## 🛠️ Setup & Running

### Prerequisites
- **Flutter SDK**: `3.41.2` or later.
- **Dart SDK**: `3.11.0` or later.

### 1. Fetch Dependencies
Navigate to the `frontend/` directory and run:
```bash
flutter pub get
```

### 2. Configure the Backend URL
By default, the application is configured to connect to `http://10.0.2.2:8000` (which refers to the host localhost inside the Android Emulator).
To change this:
1. Open the app.
2. Tap the **Settings Gear** at the top right of the Dashboard.
3. Edit the **Backend URL / Server IP** field.
4. Tap **Test Connection** to verify host accessibility, then click **Save URL**.

### 3. Run the App
Launch on an emulator or connected device:
```bash
flutter run
```

---

## 🏛️ Architecture & Coding Standards

- **Null Safety**: 100% null-safe Dart.
- **MVVM Pattern**:
  - **Models**: Simple data classes mapping JSON payload values.
  - **Views**: Render UI layouts using custom widgets. Views watch ViewModels to react to changes.
  - **ViewModels**: Handle business logic, API requests, and local database storage, completely separate from build functions.
- **Riverpod Providers**:
  - `settingsProvider`: Exposes the dark mode state, backend Base URL, and connection health results.
  - `predictionProvider`: Manages form loading indicators, stores request/response history lists, and exposes helper operations.
>>>>>>> 2a7e96a (initial)
