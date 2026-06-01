# Campus Lost & Found — Setup Guide

## Prerequisites

1. **Install Flutter** — https://docs.flutter.dev/get-started/install/windows
2. **Install Android Studio** (includes Android SDK and emulator)
3. **Create a Firebase project** at https://console.firebase.google.com

---

## Firebase Setup

### 1. Create a Firebase project
- Go to Firebase Console → Add project → name it `campus-lost-found`
- Enable Google Analytics (optional)

### 2. Enable Firebase services
In your Firebase project:
- **Authentication** → Sign-in method → Enable **Email/Password**
- **Firestore Database** → Create database → Start in **test mode** (change rules before production)

Note: Firebase Storage is NOT used. Images are stored on Cloudinary (see setup below).

### 3. Configure this app
Install FlutterFire CLI and auto-generate `firebase_options.dart`:

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Login to Firebase
firebase login

# Run from the project root — this overwrites lib/firebase_options.dart
flutterfire configure
```

Or manually replace the placeholder values in `lib/firebase_options.dart`
with the config from Firebase Console → Project Settings → Your apps.

### 4. Add google-services.json (Android)
Download `google-services.json` from Firebase Console →
Project Settings → Your apps → Android app
and place it in `android/app/`.

---

## Cloudinary Setup (Image Storage)

Images are uploaded directly from the app to Cloudinary using an unsigned upload preset. No API secret is stored in the app.

### 1. Create a Cloudinary account
Go to https://cloudinary.com and sign up for a free account.

### 2. Get your cloud name
In the Cloudinary dashboard, your **Cloud Name** is shown at the top. The app is currently configured to use cloud name `dyijsshbr`.

### 3. Create an unsigned upload preset
- Go to **Settings** → **Upload** → scroll to **Upload presets**
- Click **Add upload preset**
- Set **Signing Mode** to **Unsigned**
- Give it the name `campus_lost_found`
- Configure any folder or transformation rules as desired, then save

### 4. How it works
When a user posts an item, the app sends the selected image to:

```
POST https://api.cloudinary.com/v1_1/dyijsshbr/image/upload
```

with `upload_preset=campus_lost_found`. Cloudinary returns a JSON response containing `secure_url`, which the app stores as `imageUrl` in the Firestore item document. All image display throughout the app loads from that HTTPS URL.

To use a different cloud name or preset, update the constants in `lib/services/storage_service.dart`.

---

## Firestore Security Rules (Production)

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{uid} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == uid;
    }
    match /items/{itemId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null &&
        (resource.data.postedByUid == request.auth.uid ||
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin');
    }
  }
}
```

---

## Running the App

```bash
# 1 — Get dependencies
flutter pub get

# 2 — Run on a connected device or emulator
flutter run

# 3 — Build APK for release
flutter build apk --release
```

---

## Project Structure

```
lib/
├── main.dart                     # Entry point
├── firebase_options.dart         # Firebase config (auto-generated)
├── core/
│   ├── app_colors.dart           # Full color palette (light + dark)
│   ├── app_theme.dart            # Material 3 theme + ThemeExtension
│   └── app_constants.dart        # Categories, locations, statuses
├── models/
│   ├── item_model.dart           # Item data model + Firestore serialization
│   └── user_model.dart           # User data model
├── services/
│   ├── auth_service.dart         # Firebase Auth wrapper
│   ├── firestore_service.dart    # Firestore CRUD + streams
│   └── storage_service.dart      # Cloudinary image upload (unsigned preset)
├── providers/
│   ├── auth_provider.dart        # Auth state (ChangeNotifier)
│   ├── items_provider.dart       # Items state + search
│   └── theme_provider.dart       # Light/dark mode toggle + persistence
└── screens/
    ├── splash_screen.dart        # Animated splash with CLF logo
    ├── welcome_screen.dart       # Hero + floating cards + CTA buttons
    ├── auth/
    │   ├── login_screen.dart     # Email + password login
    │   └── signup_screen.dart    # 2-step signup with progress bar
    ├── home/
    │   ├── main_nav_screen.dart  # Bottom nav + Add choice sheet
    │   ├── dashboard_screen.dart # Hero card + stats + quick actions + feed
    │   ├── lost_screen.dart      # Lost items with grid/list + filter chips
    │   └── found_screen.dart     # Found items with grid/list + filter chips
    ├── search_screen.dart        # Search bar + category/location/status filters
    ├── item_detail_screen.dart   # Hero image + meta tiles + contact bar
    ├── add_item_screen.dart      # Add/Edit form with image upload
    ├── my_posts_screen.dart      # User posts + context menu
    ├── profile_screen.dart       # Profile card + stats + menu
    └── admin_screen.dart         # Moderation view
```

---

## Design System

| Token | Light | Dark |
|-------|-------|------|
| Primary | `#6E4FF6` (violet) | `#8B72FF` |
| Lost | `#F25C54` (coral) | `#FF7A6E` |
| Found | `#10B981` (emerald) | `#34D399` |
| Background | `#F7F7FA` | `#0B0B12` |
| Surface | `#FFFFFF` | `#16161F` |

Font: **Inter** (via `google_fonts` package)

---

## Item Categories
ID Card, Wallet, Keys, Books & Notes, Electronics, Calculator, USB Drive, Bag, Stationery, Clothing, Other

## Item Statuses
Active · Claimed · Returned · Closed
