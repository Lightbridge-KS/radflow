# RadFlow

> RadFlow — Streamline Workflow in Radiology

Cross-platform (web + desktop) Flutter app for radiology calculators, protocol generation, and reporting templates.

## Tech stack

| Concern | Choice |
|---|---|
| State management | `flutter_riverpod` ^3.0.3 |
| Routing | `go_router` ^17.0.0 (ShellRoute + persistent AppBar/Drawer) |
| Persistence | `shared_preferences` ^2.5.3 (`SharedPreferencesAsync`) |
| Templating | `mustachex` ^1.0.0 |
| Math rendering | `flutter_math_fork` ^0.7.2 |
| URL launching | `url_launcher` ^6.3.1 |
| i18n / dates | `intl` ^0.20.2 |
| Desktop window | `window_manager` ^0.4.4 |
| UI | Material 3, custom blue theme (light / dark / contrast variants) |
| Fonts | Local Roboto family (10 weights + italics, offline) |

## Project conventions

- **Mustache-driven output.** Every generated text artifact (protocol bodies, calculator reports) is rendered from a `.mustache` template against a small data map; assets are declared per directory in `pubspec.yaml`. Default templates ship in `lib/services/<feature>/templates/`; user overrides are stored via `SharedPreferencesAsync`.
- **Result<T, E> for fallible work.** Calculator business logic returns a sealed `Result` (`lib/core/result.dart`); UI maps the error variant to a SnackBar.
- **Services vs. screens.** `lib/services/**` is pure Dart — no Flutter imports. `lib/app/**` is the UI layer; widgets compose services and surface I/O.
- **Two-file feature pages.** Each non-trivial screen is split into `<feature>_screen.dart` (layout + state) and `_<feature>_input.dart` (input form) — see `pages/designer/`, `pages/design_ward/`.
- **Reusable input atoms.** Cascading dropdowns live in `lib/app/widgets/dropdowns_two.dart` and `dropdowns_three.dart`. The "Check ภาพ + author" trailer used by every Protocol Ward screen lives in `pages/design_ward/_ward_common_input.dart` backed by the `WardCommon` service.
- **Conventional Commits + GitHub Flow.** Default branch is `main`; feature work on `feat/*` branches via PR.

## Routes

| Path | Screen |
|---|---|
| `/` | HomeScreen |
| `/design/er` | DesignERScreen (Protocol ER, 3-level dropdowns + patient fields) |
| `/design/ward` | DesignWardGalleryScreen (body-part protocol gallery) |
| `/design/ward/cvs` | DesignCvsScreen (Protocol CVS, 2-level dropdowns + ward-common trailer) |
| `/calc` | CalculatorsGalleryScreen |
| `/calc/abdomen` | CalculatorAbdomenScreen (Prostate Volume, Spine Height Loss, Adrenal CT Washout) |
| `/calc/liver` | CalculatorLiverScreen (LIC from MRI T2*) |
| `/calc/tirads` | CalculatorTiradsScreen (multi-nodule ACR TI-RADS) |
| `/settings` | SettingsScreen (theme + persistence) |
| `/settings/templates/calc` | CalculatorTemplateEditorScreen (full-screen dialog, outside ShellRoute) |

Stub cards in the home grid + ward gallery (e.g. Protocol Chest / Abdomen / MSK) use `route: null` and render as disabled "Soon" tiles — same pattern across the app.

## Feature areas

### Navigation & shell
- `ShellLayout` provides the persistent AppBar + drawer; AppBar title is route-driven via `titleMap` in `shell_layout.dart`.
- HomeScreen has a gradient transparent AppBar; other routes use `colorScheme.inversePrimary`.
- `AppDrawer` groups routes into `ExpansionTile`s ("Design Study", "Calculator"). Add new sub-routes by appending a `ListTile` and updating `ScreenInfo` + `Routes`.

### Design Study
- **Protocol ER** (`/design/er`) — emergency-radiology CT/MRI generator. 3-level cascade (Category → Exam → Protocol) plus patient-side inputs (NPO, eGFR, premeds, ETT, C1, pregnancy, ref physician). Service: `lib/services/design/designer/`.
- **Protocol Ward** (`/design/ward`) — gallery for body-part protocols. CVS is the only active member today; Chest / Abdomen / MSK are stubs.
- **Protocol CVS** (`/design/ward/cvs`) — cardiovascular CTA/MRA generator. 2-level cascade (Exam → Protocol). Service: `lib/services/design/design_cvs/`.
- **Ward-common trailer** — every Protocol Ward screen appends a shared block: a "Check ภาพ" checkbox gating ก่อน/หลัง IV contrast sub-checkboxes, plus a `Role` dropdown (`ProtocolAuthor`: Resident / Fellow / Staff) + Name + Tel. Pressing Enter in Name/Tel triggers Generate. Widget: `pages/design_ward/_ward_common_input.dart`; service: `lib/services/design/design_ward_common/ward_common.dart`. Future ward screens consume both with two lines of wiring.

### Calculators
- Each calculator returns a data Map/Record from its service, then renders via a mustache template the user can override in `/settings/templates/calc` (live preview, dashIfBlank-style helpers in `services/design/_utils.dart`).
- TI-RADS hosts a multi-nodule input UI with real-time TR level preview and size-based FNA recommendations.
- LIC renders LaTeX formulas via `flutter_math_fork` with clickable citation URLs (`citation_url_launcher.dart`).

### Settings
- Theme switcher (System / Light / Dark) persisted via `themeProvider` (Riverpod) + `SharedPreferencesAsync`.
- Calculator template editor screen lives outside the ShellRoute as a full-screen dialog.

### Build & distribution
- App icons via `flutter_launcher_icons` (web, Windows, macOS).
- GitHub Actions workflows for web (no-CDN), Windows, and macOS builds. See `Makefile` for local equivalents.

## Layout

```
lib/
├── core/                              # result.dart (Result<T,E> sealed class)
├── app/
│   ├── enums/screen_info.dart         # Route → display title enum
│   ├── pages/
│   │   ├── designer/                  # Protocol ER
│   │   ├── design_ward/               # Ward gallery + Protocol CVS + shared trailer widget
│   │   ├── calculators/               # Calculator screens (+ tirads/ subfolder)
│   │   └── settings/                  # Calculator template editor
│   ├── providers/                     # theme_provider, snippet_templates_provider
│   ├── themes/                        # Material 3 light/dark/contrast variants
│   ├── widgets/                       # Shell, drawer, buttons, dropdowns_two/three, …
│   └── router.dart
├── services/
│   ├── calculator/
│   │   ├── shared/                    # template_renderer, parser, statistics
│   │   ├── templates/                 # Default mustache templates
│   │   └── tirads_calculator/         # TI-RADS business logic
│   ├── design/
│   │   ├── _utils.dart                # dashIfBlank, boolYesDash, getCurrentDate
│   │   ├── enums/                     # Shared design enums (e.g. ProtocolAuthor)
│   │   ├── designer/                  # Protocol ER service
│   │   ├── design_cvs/                # Protocol CVS service
│   │   └── design_ward_common/        # Ward-common trailer service (re-exports ProtocolAuthor)
│   └── preferences/                   # snippet_templates_service
└── fonts/Roboto/                      # Local font files
```

## Commands

- Use `fvm` for Flutter/Dart version management.
- See @Makefile for run / build targets (`run-web-local`, `build-web`, `build-web-local`, `build-web-local-wasm`, `serve-web-local`, `build-web-macos`, `icons`).
