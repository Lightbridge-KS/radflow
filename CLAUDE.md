# RadFlow

> RadFlow — Streamline Workflow in Radiology

## About

A Flutter app to streamline radiology workflow with calculators, protocols, and reporting templates. Currently in **active development** - UI scaffolding phase.

## Current Status

**Architecture:** Simple presentation layer (lib/app/)
- Navigation: `go_router` with `ShellRoute` pattern
- State management: Riverpod 3.x
- UI: Material 3 design system

**Implemented:**
- Navigation structure with drawer and 4 routes (/, /design/er, /calc/general, /settings)
- Dynamic AppBar with persistent shell layout
- Theme switcher (System/Light/Dark) with SharedPreferences persistence
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
│   └── router.dart
└── services/
    └── design/designer/    # Protocol generation business logic
```

## Tech Stack

- **State Management:** flutter_riverpod ^3.0.3
- **Routing:** go_router ^17.0.0
- **Persistence:** shared_preferences ^2.5.3
- **UI:** Material 3
- **Templating:** mustachex ^1.0.0
- **Utils:** intl ^0.20.2

## Commands

- Use `fvm` to manage Flutter/Dart version in this project. 