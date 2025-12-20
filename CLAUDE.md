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
- Navigation structure with drawer and routes (/, /design/er, /calc/abdomen, /calc/liver, /calc/tirads, /settings)
- Dynamic AppBar with persistent shell layout
  - Blended gradient AppBar on HomeScreen, inversePrimary on other screens
- Theme switcher (System/Light/Dark) with SharedPreferencesAsync persistence
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
- Calculators: Prostate Volume, Spine Height Loss, Adrenal CT Washout, LIC, TI-RADS
  - Business logic returns data Maps/Records for template rendering
  - Customizable Mustache templates (default + user override)
  - Settings → Calculator Templates editor with live preview
  - SharedPreferencesAsync persistence for custom templates
  - Template service with metadata (available variables, sample data)
  - Type-safe error handling with Result<T, E> pattern (sealed classes)
  - Specific validation errors displayed via SnackBar (ParseError, ValidationError, CalculationError)
  - LaTeX formula rendering with clickable citation links (LIC calculator)
  - TI-RADS: Multi-nodule assessment with real-time TR level preview, size-based FNA recommendations
- App icons configured via flutter_launcher_icons (web, Windows, macOS)
- CI/CD: GitHub Actions workflows for web (no CDN), Windows, and macOS builds

**Structure:**
```
lib/
├── core/                     # result.dart (Result<T,E> sealed class)
├── app/
│   ├── pages/
│   │   ├── designer/         # DesignER screen
│   │   ├── calculators/      # Calculator UI components + error handler
│   │   │   └── tirads/       # TI-RADS calculator (multi-nodule input cards)
│   │   └── settings/         # Calculator template editor
│   ├── widgets/              # Reusable UI components (buttons, citation_url_launcher)
│   ├── providers/            # theme_provider, snippet_templates_provider
│   ├── themes/               # Material 3 theme configurations
│   └── router.dart
├── services/
│   ├── calculator/           # Calculator business logic + calculator_error.dart
│   │   ├── shared/           # template_renderer, parser, statistics
│   │   ├── templates/        # Default Mustache templates
│   │   └── tirads_calculator/ # TI-RADS business logic (models, validation, data)
│   ├── design/designer/      # Protocol generation business logic
│   └── preferences/          # snippet_templates_service
└── fonts/Roboto/             # Local Roboto font files (offline)
```

## Tech Stack

- **State Management:** flutter_riverpod ^3.0.3
- **Routing:** go_router ^17.0.0
- **Persistence:** shared_preferences ^2.5.3
- **UI:** Material 3 with custom blue theme
- **Fonts:** Local Roboto (10 weights + italic variants)
- **Templating:** mustachex ^1.0.0
- **LaTeX Rendering:** flutter_math_fork ^0.7.2
- **URL Launcher:** url_launcher ^6.3.1
- **Utils:** intl ^0.20.2
- **Desktop:** window_manager ^0.4.4

## Commands

- Use `fvm` to manage Flutter/Dart version in this project. 
- See @Makefile 