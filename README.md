<img src="./assets/logo_black.svg#gh-dark-mode-only" height="100">
<img src="./assets/logo_white.svg#gh-light-mode-only" height="100">

---

## Well architectured Flutter apps. Fast ⚡

Rapid is based on carefully selected packages from the Flutter Community and brings their power together. No headaches about messing up your architecture when adding new features. Rapid enables developers to focus on quickly iterating and adding features.

## Core principles

### Modularity

Rapid aims to keep scopes small and thus uses a multi package approach. The packages are managed
in a mono repo using [melos](https://melos.invertase.dev/).

### Single Responsibility

Every package has its clear responsibility.

### Extensibility

Features can be added easily.

### Unidirectional Data Flow

Data only flows from the outside through the app to the view and backwards.

## Architecture

<img src="./assets/architecture.png">

### Platform-independent Packages

## `app`

## `logging`

## `di`

## `domain`

## `infrastructure`

### Platform-dependent Packages

## `app`

## `routing`

## Custom Features

### UI Packages
Pure Flutter packages containing the Design Language of the Rapid project.
What [`material`](https://docs.flutter.dev/development/ui/widgets/material), [`cupertino`](https://docs.flutter.dev/development/ui/widgets/cupertino), [`macos_ui`](https://pub.dev/packages/macos_ui) or [`fluent_ui`](https://pub.dev/packages/fluent_ui) is to Android, iOS, macOS or Windows
the UI Packages are to your Rapid project.

## `ui`

Contains platform independent Design Language.

## Platform-dependent UI Packages

Contains platform dependent Design Language. Builds on top of the platform independent `ui` package and existing ui libraries like [`material`](https://docs.flutter.dev/development/ui/widgets/material), [`cupertino`](https://docs.flutter.dev/development/ui/widgets/cupertino), [`macos_ui`](https://pub.dev/packages/macos_ui) or [`fluent_ui`](https://pub.dev/packages/fluent_ui).

