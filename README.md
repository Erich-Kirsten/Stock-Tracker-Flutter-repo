# 📈 StockTrack App

A Flutter app for real-time financial news, market data, and trading watchlists.
Includes Firebase authentication (Email & Google Sign-In) and Firestore integration.

---

## 🚀 Features

* 🔐 Firebase Email & Google Sign-In
* 📰 Real-time news from the Finnhub API
* 📍 Geolocation support
* 📊 Charts and trading interface
* 💾 Firebase Firestore user data storage

---
📁 Project Structure
lib/
🔽️ main.dart
🔽️ Screens/
🔽️ auth_page.dart
🔽️ news_page.dart
🔽️ navigation_controller.dart
🔽️ models/
🔽️ user_details.dart
🔽️ Services/
🔽️ firebase_service.dart
🔽️ firebase_options.dart

---
## 🔧 Getting Started

### Requirements

* Flutter SDK (3.x+ recommended)
* Dart >= 3.0
* Firebase project (your own or clone setup)
* Android Studio or VS Code

### Setup Instructions

1. **Install dependencies**:

   ```bash
   flutter pub get
   ```

2. **Firebase Configuration**:

   * Add your `google-services.json` to `android/app/`
   * If needed, regenerate `firebase_options.dart` using:

     ```bash
     flutterfire configure
     ```

3. **Run the app**:

   ```bash
   flutter run
   ```

---

## ❗ Important Notes

* This project requires **minSdkVersion 23** (check `android/app/build.gradle`).
*  `firebase_options.dart` or `google-services.json` were not released publicly make sure to create your own or get a  test-only keys.

---
