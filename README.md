# Campus Lost & Found

A Flutter-based Android app that helps BUITEMS university students report lost items and post found items — all in one place on campus.

---

## Overview

Campus Lost & Found is a mobile application built for the student community at BUITEMS. Students can sign up, post lost or found items with photos, browse and search active listings, and contact the person who posted an item. Items move through a simple lifecycle (active → claimed → returned / closed), giving both the poster and the finder a clear view of each item's status. The app targets Android and uses Firebase as its backend for authentication and data storage, with Cloudinary handling image uploads.

---

## Features

- **Email/password authentication** — sign up, log in, and persistent login across sessions
- **Welcome / onboarding screen** — clean entry point for new and returning users
- **Post lost or found items** — title, description, category, location, date, and an optional photo
- **Photo upload** — pick an image from the gallery; uploaded to Cloudinary and linked to the item
- **Browse by tab** — separate Lost and Found tabs on the home dashboard
- **Search and filter** — search by keyword across active listings
- **Item detail screen** — full view of an item with status badge and poster info
- **Item status lifecycle** — Active → Claimed → Returned / Closed; poster can update status
- **My Posts screen** — view and manage only your own listings
- **View poster profile** — see the public profile of who posted an item
- **User profile screen** — display name, email, phone, department, semester, and post stats
- **Edit profile** — update display name, phone, department, and semester
- **Dark mode** — full light/dark theme toggle, persisted across sessions
- **Privacy screen** — privacy and data information
- **Preferences screen** — user preference settings
- **Notifications screen** — notifications section (see Known Limitations)
- **Privacy masking** — sensitive fields (e.g. ID card numbers) are handled with care in item descriptions

---

## Tech Stack

| Layer | Technology |
|---|---|
| UI framework | Flutter 3.44.0 (Dart SDK ≥ 3.3.0) |
| Authentication | Firebase Authentication |
| Database | Cloud Firestore |
| Image storage | Cloudinary (via HTTP upload) |
| State management | Provider |
| Local persistence | Shared Preferences |

### Dependencies (`pubspec.yaml`)

```yaml
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

# HTTP client (Cloudinary image upload)
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
├── main.dart                   # App entry point; Firebase init, routing, providers
├── firebase_options.dart       # FlutterFire-generated Firebase config (no google-services.json needed)
│
├── core/
│   ├── app_colors.dart         # Central colour palette
│   ├── app_constants.dart      # App-wide constants (categories, statuses, etc.)
│   └── app_theme.dart          # Light and dark ThemeData + custom theme extension
│
├── models/
│   ├── item_model.dart         # Item data model (lost/found post)
│   └── user_model.dart         # User profile data model
│
├── services/
│   ├── auth_service.dart       # Firebase Authentication calls (sign up, sign in, sign out)
│   ├── firestore_service.dart  # Firestore CRUD for items and user profiles
│   └── storage_service.dart   # Cloudinary image upload via HTTP multipart
│
├── providers/
│   ├── auth_provider.dart      # Auth state; exposes current user to the widget tree
│   ├── items_provider.dart     # Items state; fetches and caches listings from Firestore
│   └── theme_provider.dart    # Dark/light mode toggle; persists via SharedPreferences
│
├── screens/
│   ├── splash_screen.dart      # Animated splash; routes to home or welcome after auth check
│   ├── welcome_screen.dart     # Onboarding / entry screen (login or sign-up choice)
│   ├── add_item_screen.dart    # Form to post a new lost or found item
│   ├── item_detail_screen.dart # Full detail view of a single item
│   ├── search_screen.dart      # Search and filter across listings
│   ├── my_posts_screen.dart    # Lists the current user's own posts
│   ├── poster_screen.dart      # Public profile view of another user
│   ├── profile_screen.dart     # Current user's profile and account info
│   ├── edit_profile_screen.dart# Edit name, phone, department, semester
│   ├── notifications_screen.dart # Notifications (placeholder — see Known Limitations)
│   ├── preferences_screen.dart # User preferences
│   ├── privacy_screen.dart     # Privacy and data information
│   │
│   ├── auth/
│   │   ├── login_screen.dart   # Email/password login form
│   │   └── signup_screen.dart  # New account registration form
│   │
│   └── home/
│       ├── main_nav_screen.dart  # Bottom navigation shell
│       ├── dashboard_screen.dart # Home dashboard with recent/featured items
│       ├── lost_screen.dart      # Browsable list of Lost items
│       └── found_screen.dart     # Browsable list of Found items
│
└── widgets/
    ├── item_card_widget.dart   # Reusable card for displaying an item in a list
    ├── status_badge_widget.dart# Coloured badge showing item status
    ├── avatar_widget.dart      # User avatar with initials fallback
    └── clf_logo_widget.dart    # App logo widget
```

---

## Architecture

The app follows a layered architecture:

```
Models  →  Services  →  Providers  →  Screens / Widgets
```

- **Models** define the data structures (`ItemModel`, `UserModel`).
- **Services** contain all external calls — Firebase Auth, Firestore reads/writes, and Cloudinary HTTP uploads. No Flutter/UI code lives here.
- **Providers** (via the `provider` package) consume the services and expose reactive state to the widget tree. Each provider is registered at the app root in `main.dart`.
- **Screens and widgets** read from providers using `context.watch` / `context.read` and never call Firebase directly.

Firebase handles authentication and the Firestore database. Images are uploaded directly from the device to Cloudinary over HTTPS; the returned URL is stored in the Firestore item document.

---

## Prerequisites

- **Flutter SDK 3.44.0** or later (the version this project was built and tested with)
- **Dart SDK ≥ 3.3.0** (bundled with Flutter)
- **Android Studio** or **VS Code** with the Flutter and Dart plugins installed
- An **Android device** with USB debugging enabled, or an **Android emulator**
- Internet connection (required at runtime for Firebase and Cloudinary)

> This project targets **Android only**. The `ios/`, `web/`, and desktop platform folders are Flutter-generated stubs and have not been configured or tested.

---

## How to Run

**1. Install Flutter**

Download and install Flutter from [flutter.dev](https://flutter.dev/docs/get-started/install). Confirm the installation:

```bash
flutter doctor
```

All required items (Flutter, Android toolchain, connected device) should show a green checkmark.

**2. Place the project folder**

Extract or copy the project folder to a location of your choice. The folder should contain `pubspec.yaml` at its root.

**3. Install dependencies**

Open a terminal in the project root and run:

```bash
flutter pub get
```

This downloads all packages listed in `pubspec.yaml` and generates the `.dart_tool/` files needed to build.

**4. Connect a device or start an emulator**

- **Physical device:** connect via USB, enable USB debugging in Developer Options, and confirm Flutter sees it:

  ```bash
  flutter devices
  ```

- **Emulator:** open Android Studio → Device Manager → start a virtual device (API 26 or higher recommended).

**5. Run the app**

```bash
flutter run
```

Flutter will build and deploy a debug APK to the connected device. Use `r` in the terminal to hot-reload and `R` for a full restart.

**6. Build a release APK (optional)**

```bash
flutter build apk --release
```

The output APK will be at `build/app/outputs/flutter-apk/app-release.apk`.

---

## Firebase / Backend Notes

- Firebase configuration is generated by the FlutterFire CLI and lives entirely in `lib/firebase_options.dart`. There is **no separate `google-services.json`** file — it is not needed with this setup.
- The app connects to a Firebase project for two services:
  - **Firebase Authentication** — email/password sign-up and sign-in.
  - **Cloud Firestore** — stores item listings and user profile documents.
- **Cloudinary** is used for image storage. When a user attaches a photo to an item post, the image is uploaded from the device directly to Cloudinary over HTTPS, and the resulting URL is saved in the item's Firestore document. The Cloudinary credentials (cloud name, upload preset) are stored in `lib/core/app_constants.dart`.
- No backend server or custom API is required — the app communicates directly with Firebase and Cloudinary.

---

## Known Limitations / Future Work

The following features are present in the UI but are not fully implemented:

- **Contact buttons** (Call, WhatsApp, Email on the item detail screen) — buttons exist but are placeholders and do not launch the dialler or messaging apps.
- **Notifications screen** — the screen is a placeholder; no real push notification system is wired up.
- **Change password** — accessible from the profile/preferences area but not implemented.
- **BUITEMS email verification** — no enforcement that a sign-up email belongs to a `@buitems.edu.pk` domain.
- **Admin / moderation panel** — there is no admin interface to remove inappropriate listings or manage users.
- **iOS support** — not configured or tested; Android only.

---

## Author / Course

| Field | Details |
|---|---|
| **Name** | [FILL IN] |
| **Student ID** | [FILL IN] |
| **Department** | Software Engineering |
| **Semester** | [FILL IN] |
| **Course** | [FILL IN] |
| **Instructor** | [FILL IN] |
| **Institution** | BUITEMS — Balochistan University of Information Technology, Engineering and Management Sciences |
