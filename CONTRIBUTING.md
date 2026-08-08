# Contributing to Moda Praia Santos

> Thank you for your interest! This guide covers setup, conventions, and the contribution workflow.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Project Structure](#project-structure)
- [Development Workflow](#development-workflow)
- [Coding Conventions](#coding-conventions)
- [Adding a New Feature](#adding-a-new-feature)
- [Writing Tests](#writing-tests)
- [Commit Messages](#commit-messages)
- [Pull Request Process](#pull-request-process)
- [Troubleshooting](#troubleshooting)

---

## Getting Started

### Prerequisites

- **Flutter 3.27+** — [Install guide](https://docs.flutter.dev/get-started/install)
- **Dart 3.3+** (included with Flutter)
- **Git** + **GitHub account**

### Quick Start

```bash
git clone https://github.com/<your-username>/flutter_ecommerce.git
cd flutter_ecommerce
flutter pub get
flutter run -d chrome
```

---

## Development Setup

### Running Locally

```bash
# Web (Chrome)
flutter run -d chrome

# Android
flutter run -d android

# iOS
flutter run -d ios
```

### Running Tests

```bash
flutter test

# With coverage
flutter test --coverage
```

---

## Project Structure

```
lib/
├── main.dart           # App entry point
├── app.dart            # MaterialApp config
├── data/               # Repository pattern (data sources)
├── models/             # Data models (Product, CartItem, Order)
├── pages/              # Screen widgets
├── providers/          # State management (Provider/ChangeNotifier)
├── theme/              # Design system (colors, themes)
├── utils/              # Helpers (FakePix)
└── widgets/            # Reusable UI components
```

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed architecture docs.

---

## Development Workflow

### Branch Naming

| Type | Format | Example |
|---|---|---|
| Feature | `feat/description` | `feat/wishlist` |
| Bug fix | `fix/description` | `fix/cart-persistence` |
| Docs | `docs/description` | `docs/api-guide` |
| Refactor | `refactor/description` | `refactor/theme-system` |
| Test | `test/description` | `test/catalog-provider` |
| Chore | `chore/description` | `chore/update-deps` |

### Workflow

```
master ───────────────────────────────────────
  └── feat/your-feature ── commit ── PR ── merge
```

1. Create branch from `master`:
   ```bash
   git checkout master && git pull
   git checkout -b feat/your-feature
   ```
2. Make changes, write tests.
3. Commit with conventional messages.
4. Push and open a PR.

---

## Coding Conventions

### Dart & Flutter

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart).
- `flutter_lints` is configured in `analysis_options.yaml`.
- Classes: `PascalCase`, files: `snake_case`.
- Private members: prefix with `_`.

### Provider Pattern

- Controllers extend `ChangeNotifier`.
- Use `notifyListeners()` after state mutations.
- Register via `ChangeNotifierProvider` at the root.

### Repository Pattern

- Data sources implement the abstract `ProductRepository`.
- UI depends only on the abstract interface, never on implementations.
- This enables swapping data sources without changing widgets.

### Models

- Immutable where possible (`final` fields).
- Include `toJson()` and `fromJson()` for serialization.
- Keep models free of UI or business logic.

---

## Adding a New Feature

### Example: Adding a Wishlist

1. **Model**: Create `lib/models/wishlist_item.dart`.
2. **Provider**: Create `lib/providers/wishlist_provider.dart` extending `ChangeNotifier`.
3. **Repository**: Create `lib/data/wishlist_repository.dart` (abstract + demo implementation).
4. **Pages**: Create UI pages under `lib/pages/`.
5. **Register**: Add `ChangeNotifierProvider` in `main.dart`.
6. **Tests**: Add unit tests in `test/`.
7. **Update docs**: Update `ARCHITECTURE.md` if architecture changed.

---

## Writing Tests

### Test Structure

```
test/
├── widget_test.dart              # Smoke test (app starts)
├── cart_provider_test.dart       # Cart CRUD + persistence
├── product_model_test.dart       # Product serialization
├── order_model_test.dart         # Order creation
├── cart_item_model_test.dart      # CartItem total calculation
├── catalog_provider_test.dart     # Catalog filtering
└── currency_test.dart            # BRL formatting
```

### Running Tests

```bash
flutter test                    # All tests
flutter test test/unit/foo.dart  # Specific file
flutter test --coverage          # With coverage report
```

### Test Guidelines

- **Model tests**: Verify `fromJson()`, `toJson()`, round-trip.
- **Provider tests**: Mock dependencies, verify state changes + notifications.
- **Widget tests**: Test rendering and user interactions.
- Use `SharedPreferences.setMockInitialValues({})` for cart persistence tests.

---

## Commit Messages

Follow **Conventional Commits**:

```
<type>(<scope>): <description>
```

| Type | Purpose |
|---|---|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation |
| `refactor` | Code refactoring |
| `test` | Tests |
| `chore` | Build/config |

---

## Pull Request Process

1. Ensure CI passes (analyze + test).
2. Update documentation if needed.
3. Include tests for new features.
4. Keep PRs focused on one concern.

---

## Troubleshooting

| Problem | Solution |
|---|---|
| `flutter pub get` fails | Check Flutter version (3.27+) and pubspec.yaml |
| Images not loading | Ensure `images/products/` assets are present |
| Web deploy fails | Check CI logs in GitHub Actions tab |
| Cart lost on refresh | `SharedPreferences` may be blocked in some browsers |

---

Open an [issue](https://github.com/Alexsantossp71/flutter_ecommerce/issues) for questions!

Happy coding!
