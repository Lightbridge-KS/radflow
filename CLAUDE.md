# RadFlow

> RadFlow — Streamline Workflow in Radiology

## About

A cross-platform (web and desktop) Flutter app to streamline radiology workflow with calculators, protocols, and reporting templates.

## Current Status

- Navigation: `go_router` with `ShellRoute` pattern
- State management: Riverpod 3.x
- UI: Material 3 design system
- Theme: Blue color scheme (lib/app/themes/theme_blue.dart)
- Fonts: Local Roboto fonts (fonts/Roboto/) for offline deployment

**Implemented:**
- Navigation structure with drawer and 4 routes (/, /design/er, /calc/general, /settings)
- Dynamic AppBar with persistent shell layout
  - Blended gradient AppBar on HomeScreen, inversePrimary on other screens
- Theme switcher (System/Light/Dark) with SharedPreferences persistence
- Custom Material 3 theme with light/dark/contrast variants
- HomeScreen: Modern Material 3 welcome page
  - Hero section with gradient background and decorative dots
  - Responsive feature cards grid (max 350px/card, constrained 1200px container)
  - Cards link to DesignER, Calculators (with stub placeholders for Protocols, Reports)
- DesignER Screen: Protocol generator for CT/MRI Emergency Radiology studies
  - Three-level dropdown selection (Category → Exam → Protocol)
  - Mustache-based template generation (lib/services/design/designer/)
  - Responsive layout with input form and output display
  - Shared UI components (ThreeLevelDropdowns, GenerateButton, CopyButton)
- App icons configured via flutter_launcher_icons (web, Windows, macOS)
- CI/CD: GitHub Actions workflows for web (no CDN), Windows, and macOS builds

**Pending:**
- Feature content for calculators

**Structure:**
```
lib/
├── app/
│   ├── pages/
│   │   └── designer/       # DesignER screen (implemented)
│   ├── widgets/            # Reusable UI components
│   ├── providers/          # theme_provider
│   ├── themes/             # Material 3 theme configurations
│   └── router.dart
├── services/
│   └── design/designer/    # Protocol generation business logic
└── fonts/Roboto/           # Local Roboto font files (offline)
```

## Tech Stack

- **State Management:** flutter_riverpod ^3.0.3
- **Routing:** go_router ^17.0.0
- **Persistence:** shared_preferences ^2.5.3
- **UI:** Material 3 with custom blue theme
- **Fonts:** Local Roboto (10 weights + italic variants)
- **Templating:** mustachex ^1.0.0
- **Utils:** intl ^0.20.2
- **Desktop:** window_manager ^0.4.4

## Commands

- Use `fvm` to manage Flutter/Dart version in this project. 
- See @Makefile 