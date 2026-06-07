# Campus Lost & Found

A Flutter Android app for BUITEMS students to report, search, and recover lost and found items on campus.

---

## Overview

Campus Lost & Found is a mobile application built for the student community at Balochistan University of Information Technology, Engineering and Management Sciences (BUITEMS). It gives students a central place to post lost or found items with photos, browse and search listings by category or location, and coordinate item returns through a structured status lifecycle — all backed by Firebase and Cloudinary with no custom backend server.

---

## Features

- **Email/password authentication** with persistent login (session survives app restarts)
- **Splash screen** with animated BUITEMS branding, then auto-route based on auth state
- **Post items** — report a lost or found item; a photo is **required** when creating a post
- **Camera + gallery upload** — pick an image from the gallery or capture one with the camera; uploaded to Cloudinary via HTTP
- **Lost tab / Found tab** — separate browsable lists for each item type
- **Dashboard** — at-a-glance stats and recent activity
- **Search & filter** — full-text search with filters for item type, category, location, and status
- **Item detail** — full photo, description, status badge, and poster info
- **Status lifecycle** — items move through `active → claimed → returned → closed`
- **My Posts** — view and manage your own listings
- **Poster profile** — tap any poster to view their public profile
- **Profile & edit profile** — view and update display name, avatar, and contact info
- **Dark mode** — system-aware with manual toggle; preference persisted via Shared Preferences
- **Privacy masking** — ID card numbers are partially masked in the UI to protect sensitive data
- **Preferences, Privacy, and Notifications screens** — in-app settings navigation

---

## Tech Stack

| Layer | Technology |
|---|---|
| UI Framework | Flutter (Dart) |
| Authentication | Firebase Auth |
| Database | Cloud Firestore |
| Image Storage | Cloudinary (HTTP multipart upload) |
| State Management | Provider |
| Local Persistence | Shared Preferences |

### Dependencies (`pubspec.yaml`)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Firebase
  firebase_core: ^3.13.0
  firebase_auth: ^5.5.1
  cloud_firestore: ^5.6.0
  firebase_storage: ^12.4.3

  # State management
  provider: ^6.1.5

  # UI & fonts
  google_fonts: ^6.2.1
  cached_network_image: ^3.4.1

  # Image picker
  image_picker: ^1.1.2

  # HTTP client (Cloudinary upload)
  http: ^1.2.2

  # Utilities
  intl: ^0.19.0
  url_launcher: ^6.3.1
  shared_preferences: ^2.3.3
  uuid: ^4.5.1
  cupertino_icons: ^1.0.8
```

---

## Project Structure

```
lib/
├── main.dart                          # App entry point; Firebase init; Provider setup
├── firebase_options.dart              # FlutterFire-generated Firebase config (no google-services.json needed)
│
├── core/
│   ├── app_colors.dart                # Centralized color palette (light + dark)
│   ├── app_constants.dart             # Cloudinary cloud name/preset; app-wide string constants
│   └── app_theme.dart                 # ThemeData definitions for light and dark modes
│
├── models/
│   ├── item_model.dart                # Data class for a lost/found item (Firestore ↔ Dart)
│   └── user_model.dart                # Data class for a user profile (Firestore ↔ Dart)
│
├── services/
│   ├── auth_service.dart              # Firebase Auth calls (sign in, sign up, sign out)
│   ├── firestore_service.dart         # All Firestore reads/writes (items, users)
│   └── storage_service.dart           # Cloudinary HTTP upload logic
│
├── providers/
│   ├── auth_provider.dart             # Auth state; wraps AuthService; exposes current user
│   ├── items_provider.dart            # Item list state; wraps FirestoreService + StorageService
│   └── theme_provider.dart            # Dark/light mode toggle; persists via SharedPreferences
│
├── screens/
│   ├── splash_screen.dart             # Animated launch screen; routes to welcome or home
│   ├── welcome_screen.dart            # Landing page with login/signup buttons
│   ├── add_item_screen.dart           # Form to post a new lost/found item with required photo
│   ├── item_detail_screen.dart        # Full item view; status update controls; poster link
│   ├── search_screen.dart             # Search bar + filter chips (type/category/location/status)
│   ├── my_posts_screen.dart           # Current user's own listings
│   ├── poster_screen.dart             # Public profile view of any item's poster
│   ├── profile_screen.dart            # Logged-in user's own profile
│   ├── edit_profile_screen.dart       # Edit display name, avatar, and contact info
│   ├── notifications_screen.dart      # Notifications placeholder screen
│   ├── preferences_screen.dart        # App preferences (dark mode toggle, etc.)
│   ├── privacy_screen.dart            # Privacy policy / data info screen
│   │
│   ├── auth/
│   │   ├── login_screen.dart          # Email/password login form
│   │   └── signup_screen.dart         # New account registration form
│   │
│   └── home/
│       ├── main_nav_screen.dart       # Bottom nav shell (Lost / Found / Dashboard)
│       ├── dashboard_screen.dart      # Stats cards and recent items
│       ├── lost_screen.dart           # Paginated list of lost-item posts
│       └── found_screen.dart          # Paginated list of found-item posts
│
└── widgets/
    ├── avatar_widget.dart             # Circular avatar with fallback initials
    ├── clf_logo_widget.dart           # BUITEMS-branded app logo widget
    ├── item_card_widget.dart          # Reusable card tile for item lists
    └── status_badge_widget.dart       # Colored badge showing item status
```

---

## Architecture

The app follows a layered architecture:

```
Models  →  Services  →  Providers  →  Screens / Widgets
```

- **Models** (`item_model.dart`, `user_model.dart`) define plain Dart data classes with `fromMap`/`toMap` serialization for Firestore.
- **Services** (`auth_service.dart`, `firestore_service.dart`, `storage_service.dart`) are thin wrappers around Firebase Auth, Cloud Firestore, and the Cloudinary HTTP API. They contain no UI logic.
- **Providers** (`auth_provider.dart`, `items_provider.dart`, `theme_provider.dart`) use the `provider` package to hold and expose reactive state. They call services and notify listeners when state changes.
- **Screens and Widgets** consume providers via `context.watch` / `context.read`. They never call Firebase or Cloudinary directly.

Firebase handles authentication and the Firestore document database. Cloudinary handles image storage — photos are uploaded via an HTTP multipart `POST` and the returned URL is saved to Firestore.

---

## Prerequisites

- **Flutter SDK** `>=3.3.0 <4.0.0` (built and tested on Flutter 3.x stable)
- **Dart SDK** (bundled with Flutter)
- **Android Studio** or **VS Code** with the Flutter and Dart plugins installed
- An **Android device** or **emulator** (API 21+)
- **Internet connection** (required at runtime for Firebase and Cloudinary)

> **Android only.** iOS targets have not been configured.

---

## How to Run

1. **Place the project folder — read this carefully on Windows:**

   > - The project folder **must be on the same drive as your Flutter SDK** (e.g. Flutter on `C:\` → project on `C:\`). Putting the project on a different drive (e.g. `D:\`) causes a Kotlin cross-drive build error and the app will not compile.
   > - The folder path **must not contain spaces or special characters** such as `&`. Use a plain path like `C:\dev\campus_lost_found`.

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Connect an Android device** with USB debugging enabled.

   > **Xiaomi / Redmi phones / Any Andriod Phones:** In addition to USB debugging, you must also enable **"Install via USB"** in Developer Options — without it the build succeeds but the app fails to install on the device.

   Confirm Flutter detects the device:

   ```bash
   flutter devices
   ```

4. **Run the app:**

   ```bash
   flutter run
   ```

5. **Build a release APK** (optional):

   ```bash
   flutter build apk --release
   ```

   Output: `build/app/outputs/flutter-apk/app-release.apk`

---

## Firebase / Backend Notes

- Firebase configuration is generated by the FlutterFire CLI and lives in `lib/firebase_options.dart`. There is **no separate `google-services.json`** file needed.
- **Firebase Authentication** handles all user sign-up and sign-in (email/password).
- **Cloud Firestore** stores all item posts and user profile documents.
- **Cloudinary** stores all images. When a user attaches a photo to a post, the image is uploaded directly from the device to Cloudinary over HTTPS; the returned URL is saved in the Firestore item document. The Cloudinary cloud name and unsigned upload preset are defined in `lib/core/app_constants.dart`.
- No custom backend server is required — the app communicates directly with Firebase and Cloudinary.

---

## Known Limitations / Future Work

- **Contact buttons** (Call, Email, WhatsApp on the item detail screen) are rendered but are placeholders — they do not yet launch the dialer or messaging apps.
- **Notifications screen** is a placeholder; real push notifications have not been implemented.
- **Change password** is not implemented on the profile/settings screens.
- **No BUITEMS email-domain verification** — any valid email address can register; `.edu.pk` domain enforcement is not in place.
- **No admin or moderation panel** — there is no backend dashboard for reviewing or removing posts.
- **iOS not configured** — no Runner scheme, no Apple bundle identifiers. Android only.

---

## Author / Course

| Field | Detail |
|---|---|
| **Name** | Abdullah |
| **Student ID (CMSID)** | 62724 |
| **Department** | Software Engineering |
| **Semester** | 6th |
| **Course** | CN |
| **Instructor** | Miss Poma Panezai |
| **Institution** | BUITEMS |
