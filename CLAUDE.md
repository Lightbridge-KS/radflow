# RadFlow

> RadFlow — Streamline Workflow in Radiology

## About

A cross-platform (web and desktop) Flutter app to streamline radiology workflow with calculators, protocols, and reporting templates.

## Current Status

**Architecture:** Simple presentation layer (lib/app/)
- Navigation: `go_router` with `ShellRoute` pattern
- State management: Riverpod 3.x
- UI: Material 3 design system
- Theme: Blue color scheme (lib/app/themes/theme_blue.dart)
- Fonts: Local Roboto fonts (fonts/Roboto/) for offline deployment

**Implemented:**
- Navigation structure with drawer and 4 routes (/, /design/er, /calc/general, /settings)
- Dynamic AppBar with persistent shell layout
- Theme switcher (System/Light/Dark) with SharedPreferences persistence
- Custom Material 3 theme with light/dark/contrast variants
- DesignER Screen: Protocol generator for CT/MRI Emergency Radiology studies
  - Three-level dropdown selection (Category → Exam → Protocol)
  - Mustache-based template generation (lib/services/design/designer/)
  - Responsive layout with input form and output display
  - Shared UI components (ThreeLevelDropdowns, GenerateButton, CopyButton)

**Pending:**
- Feature content for calculators
- Clean Architecture refactoring (domain/data/presentation layers)

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