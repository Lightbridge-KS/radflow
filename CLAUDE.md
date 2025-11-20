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

**Pending:**
- Clean Architecture layers (domain, data, presentation separation)
- Feature content for calculators and protocols
- Business logic and use cases

**Structure:**
```
lib/app/
├── pages/        # Screen widgets (placeholders)
├── widgets/      # shell_layout, app_drawer
├── providers/    # theme_provider
└── router.dart   # Route configuration
```

## Tech Stack

- **State Management:** flutter_riverpod ^3.0.3
- **Routing:** go_router ^17.0.0
- **Persistence:** shared_preferences ^2.5.3
- **UI:** Material 3

## Commands

- Use `fvm` to manage Flutter/Dart version in this project. 