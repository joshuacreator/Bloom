# Bloom

A feature-rich social platform built with Flutter — think Slack + Discord for organized communities. Create spaces, join rooms, send messages, share media, and manage your academic life, all in one place.

## Features

- **Spaces** — Create or discover communities around any topic. Each space has its own set of rooms.
- **Rooms** — Topic-based chat channels within a space. Join conversations that matter to you.
- **Messaging** — Real-time text messaging with image/file sharing, replies, and edit/delete.
- **Authentication** — Email/password sign-up with email verification, password reset.
- **Profiles** — Customizable display name, photo, and bio.
- **Academics** — Course management module for students (add courses, track activities).
- **Theme Switching** — Light and dark mode.

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | [Flutter](https://flutter.dev) |
| Language | [Dart](https://dart.dev) |
| State Management | [Riverpod](https://riverpod.dev) |
| Routing | [go_router](https://pub.dev/packages/go_router) |
| Backend | [Firebase](https://firebase.google.com) (Auth, Firestore, Storage, Functions) |
| Networking | [Dio](https://pub.dev/packages/dio) |
| Notifications | Firebase Cloud Messaging |
| Image Handling | image_picker, image_cropper |

See [RULES.md](RULES.md) for the full architectural guide.

## Project Structure

```
lib/
├── features/               # Feature-first architecture
│   ├── auth/              # Login, register, password reset, email verification
│   ├── room/              # Room chat screens and providers
│   ├── message/           # Message details, replies, message tiles
│   ├── space/             # Space discovery, creation, settings
│   ├── profile/           # User profile, settings, theme picker
│   ├── academics/         # Course management
│   └── direct_message/    # Direct messaging (in progress)
├── core/                   # Shared foundation
│   ├── constants/         # App-wide constants (spacing, defaults)
│   ├── theme/             # Colors, text styles, theme provider
│   ├── utils/             # Helpers (connection state, extensions, date/time)
│   ├── exceptions/        # Custom exception classes
│   ├── network/           # Dio client, interceptors
│   └── config/            # Environment config
├── common/                 # Reusable widgets
│   └── widgets/           # AppButton, AppTextField, SnackBar, loading indicators, etc.
├── views/                  # Legacy screens (being migrated to features/)
├── models/                 # Legacy data models (being migrated to features/*/domain/entities/)
├── services/               # Legacy service classes (being migrated to core/utils/)
├── providers/              # Legacy state providers (being migrated to features/*/presentation/providers/)
└── configs/                # Legacy config (being migrated to core/)
```

> **Note:** The project is actively being refactored to a clean architecture. The `views/`, `models/`, `services/`, and `configs/` directories contain legacy code that is gradually being moved into `features/`, `core/`, and `common/`.

## Getting Started

### Prerequisites

- Flutter SDK (3.x or later) — [Install guide](https://docs.flutter.dev/get-started/install)
- A Firebase project — [Create one here](https://console.firebase.google.com)
- An iOS or Android device/emulator

### Setup

1. **Clone the repo**

   ```bash
   git clone <repo-url>
   cd Bloom
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure Firebase**

   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the respective platform directories.
   - Enable **Email/Password** authentication in Firebase Console.
   - Create a **Cloud Firestore** database.
   - Set up **Firebase Storage** for image/file uploads.

4. **Set up environment variables**

   Create a `.env` file in the project root:

   ```env
   FIREBASE_API_KEY=your_api_key
   FIREBASE_APP_ID=your_app_id
   FIREBASE_MESSAGING_SENDER_ID=your_sender_id
   FIREBASE_PROJECT_ID=your_project_id
   ```

5. **Run the app**

   ```bash
   flutter run
   ```

### Platform-specific notes

- **iOS**: Open `ios/Runner.xcworkspace` in Xcode and configure your development team under Signing & Capabilities.
- **Android**: Ensure `google-services.json` is placed in `android/app/`.

## Architecture

Bloom follows a **feature-first clean architecture**:

```
Feature
├── data/         # DTOs, data sources, repository implementations
├── domain/       # Entities, abstract repositories, use cases (pure Dart)
└── presentation/ # Screens, widgets, Riverpod notifiers/providers
```

- **Data layer** talks to Firebase and other external sources.
- **Domain layer** contains business logic with zero Flutter dependencies.
- **Presentation layer** handles UI and state via Riverpod.

Shared code lives in `core/` (theme, constants, utils) and `common/` (reusable widgets).

## Commands

| Command | Purpose |
|---|---|
| `flutter run` | Run the app |
| `flutter analyze` | Check for lint and type errors |
| `flutter build apk` | Build Android APK |
| `flutter build ios` | Build iOS app |
| `flutter test` | Run tests |

## Environment

The app uses `flutter_dotenv` for configuration. A `.env` file is required at the project root with Firebase credentials. Never commit `.env` to version control — the `.gitignore` already excludes it.

## License

This project is licensed under the MIT License — see the LICENSE file for details.
