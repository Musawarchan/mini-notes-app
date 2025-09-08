# Notes Mini App

A compact Flutter application for note‑taking and browsing remote posts. It features Material 3 theming, offline‑friendly UX, and a lightweight splash screen.

## Requirements

- Flutter 3.24+ (Dart 3.6+)
- Platforms: Android, iOS, Web, macOS, Windows, Linux

## Quick start

```bash
git clone <your-repo-url>
cd notes_mini_app
flutter pub get 
flutter run
```

## Project structure

```
lib/
├── core/                    # Core utilities and constants
│   ├── constants/          # App constants
│   ├── theme/             # Material 3 theming
│   └── utils/             # Storage service
├── data/                   # Data layer
│   ├── models/            # Data models
│   ├── repositories/      # Data repositories
│   └── services/          # API services
├── features/               # Feature modules
│   ├── notes/             # Notes feature
│   │   ├── view/          # Views
│   │   ├── viewmodel/     # ViewModels
│   │   └── widgets/       # Reusable widgets
│   ├── posts/             # Posts feature
│   │   ├── view/
│   │   ├── viewmodel/
│   │   └── widgets/
│   ├── settings/           # Settings feature
│   │    ├── view/
│   │    └── viewmodel/
│   └── splash/              # Splash screen
├── app.dart               # Main app configuration
└── main.dart              # App entry point
```

## Features

- Notes (local)
  - Add, edit, delete notes
  - Undo deletion via SnackBar
  - Persisted with SharedPreferences
- Posts (remote)
  - Fetch from `https://jsonplaceholder.typicode.com/posts`
  - Paged loading with pull‑to‑refresh and infinite scroll
  - Shimmer on initial load, inline error UI with Retry
- Settings / Theme
  - Light/Dark themes and seed color selection
  - Preferences persisted across launches
- Splash
  - Minimal splash that navigates to the main app

## State management

- Provider + ChangeNotifier for view models
- Consumer widgets for granular rebuilds
- Initialization is deferred to post‑frame callbacks when needed to prevent build‑phase notifications

## Networking & error handling

- `http` package for requests
- Friendly, user‑facing error copy (no raw exceptions)
- Retry flows for initial load and pagination

## Dependencies

- provider: state management
- shared_preferences: lightweight persistence
- http: networking
- shimmer: loading skeletons

## Development

Common commands:

```bash
# Run
flutter run 
```

## Build

```bash
flutter build apk      # Android
flutter build ios      # iOS
flutter build web      # Web
```

## Design decisions

- Favor simplicity (Provider) over added boilerplate for this scope
- Separate data/services from UI via a light MVVM approach
- Cache preferences (theme, seed color) using SharedPreferences
- Prioritize resilient UX offline: stable empty/error states; shimmer only during initial loads


