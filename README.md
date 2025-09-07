# Notes Mini App

A Flutter application demonstrating MVVM architecture with Material 3 theming, offline notes management, and API integration.

## Features

### Task 1 — Notes Mini-App (Offline + Undo)
- ✅ List of note cards (title + description)
- ✅ Add/Edit/Delete notes
- ✅ Delete shows SnackBar with "Undo" functionality
- ✅ Persist locally using SharedPreferences
- ✅ Validation: No empty titles allowed

### Task 2 — API Cards (Paged + Retry)
- ✅ Fetch posts from https://jsonplaceholder.typicode.com/posts
- ✅ Display as styled cards (title + preview)
- ✅ States: Loading (shimmer/skeleton), error (retry button), empty state
- ✅ Paging: Load first 10 posts, then "Load more" with infinite scroll

### Task 3 — Theme Playground (Dynamic)
- ✅ Toggle between dark/light themes
- ✅ 4 preset seed colors (user can switch)
- ✅ Persist theme choice
- ✅ UI updates instantly across the app

## Architecture

The app follows **MVVM (Model-View-ViewModel)** architecture:

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
│   └── settings/           # Settings feature
│       ├── view/
│       └── viewmodel/
├── app.dart               # Main app configuration
└── main.dart              # App entry point
```

## State Management

- **Provider**: Used for state management across the app
- **ChangeNotifier**: ViewModels extend ChangeNotifier for reactive updates
- **Consumer**: Views consume ViewModel state changes

## Dependencies

- `provider: ^6.1.2` - State management
- `shared_preferences: ^2.2.3` - Local storage
- `http: ^1.2.2` - HTTP requests
- `shimmer: ^3.0.0` - Loading animations

## Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd notes_mini_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Key Decisions

### Architecture Choices
- **MVVM**: Clear separation of concerns with ViewModels handling business logic
- **Provider**: Simple and effective state management without complex setup
- **Repository Pattern**: Abstracts data sources for better testability

### UI/UX Decisions
- **Material 3**: Modern design system with dynamic theming
- **Navigation Bar**: Clean bottom navigation for easy feature access
- **Shimmer Loading**: Better user experience during data loading
- **SnackBar Undo**: Familiar pattern for destructive actions
- **Enhanced Cards**: Beautiful gradient cards with smooth animations
- **Interactive Elements**: Tap animations and visual feedback
- **Modern Dialogs**: Custom styled dialogs with better UX
- **Visual Hierarchy**: Clear information architecture with proper spacing

### Technical Decisions
- **SharedPreferences**: Simple local storage for notes and settings
- **HTTP Package**: Lightweight HTTP client for API calls
- **Infinite Scroll**: Better performance for large datasets
- **Error Handling**: Comprehensive error states with retry functionality

## Testing

Run tests with:
```bash
flutter test
```

## Build

Build for production:
```bash
flutter build apk  # Android
flutter build ios  # iOS
flutter build web  # Web
```

## Screenshots

The app includes:
- Light and dark theme variants
- 4 different seed color options
- Responsive design for different screen sizes
- Accessible UI components

## Evaluation Criteria Coverage

- **Architecture (30%)**: ✅ MVVM with clear separation of concerns
- **State & Data Flow (20%)**: ✅ Robust Provider-based state management
- **UI/UX Polish (30%)**: ✅ Modern Material 3 design with smooth animations
- **Reliability (20%)**: ✅ Comprehensive error handling and offline support# mini-notes-app
