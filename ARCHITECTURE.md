# Architecture — Moda Praia Santos (flutter_ecommerce)

> Complete guide to the architecture, patterns, and design decisions of the Moda Praia Santos Flutter e-commerce application.

## Table of Contents

- [Overview](#overview)
- [Technology Stack](#technology-stack)
- [High-Level Architecture](#high-level-architecture)
- [Project Structure](#project-structure)
- [State Management — Provider](#state-management--provider)
- [Data Layer & Repository Pattern](#data-layer--repository-pattern)
- [Models](#models)
- [Pages & Navigation](#pages--navigation)
- [Responsive Layout](#responsive-layout)
- [Theme & Design System](#theme--design-system)
- [PIX Payment Simulation](#pix-payment-simulation)
- [Persistence](#persistence)
- [CI/CD Pipeline](#cicd-pipeline)
- [Design Decisions](#design-decisions)

---

## Overview

Moda Praia Santos is a **Flutter e-commerce app** for beach fashion, built as a portfolio project. It features a product catalog with search and category filtering, a persistent shopping cart, a full checkout flow with simulated PIX payment (QR code), and order confirmation — all running on **GitHub Pages** with no backend required.

The app uses **Provider** for state management, a **Repository pattern** for data access, and a **custom PIX payload generator** for realistic payment simulation.

---

## Technology Stack

| Layer | Technology | Purpose |
|---|---|---|
| **Framework** | Flutter (Dart 3.3+) | Cross-platform UI (Web, Android, iOS) |
| **State Management** | Provider 6.1+ | Cart state, catalog state, UI rebuilds |
| **Persistence** | shared_preferences | Cart persistence across sessions |
| **Payment Sim** | FakePix (custom) | Generates valid-looking EMV PIX payloads |
| **QR Code** | qr_flutter | Renders PIX QR codes on checkout |
| **CI/CD** | GitHub Actions | Lint, test, deploy to GitHub Pages |
| **Hosting** | GitHub Pages | Web deployment |

---

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter App                           │
│                                                          │
│  ┌───────────┐    ┌──────────────────┐    ┌───────────┐ │
│  │   Pages    │───>│   Providers      │───>│ Repository│ │
│  │ (Widgets) │ <───│ (ChangeNotifier) │ <───│  (Data)   │ │
│  └───────────┘    └──────────────────┘    └───────────┘ │
│       │                  │                      │        │
│       │            ┌─────┴─────┐               │        │
│       │            │           │               │        │
│       │      CartProvider  CatalogProvider     │        │
│       │            │           │               │        │
│       │      SharedPreferences  DemoProductRepo │        │
│       │            │           │               │        │
│  ┌────┴────────────┴───────────┴───────────────┴────┐  │
│  │              Models (Product, CartItem, Order)     │  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

---

## Project Structure

```
lib/
├── main.dart                    # Entry point, MultiProvider setup
├── app.dart                     # MaterialApp root widget
├── data/
│   ├── product_repository.dart  # Abstract interface
│   └── demo_product_repository.dart  # Mock catalog (10 products)
├── models/
│   ├── product.dart             # Product entity
│   ├── cart_item.dart            # Cart line item (product + qty)
│   └── order.dart               # Confirmed order
├── pages/
│   ├── home_page.dart           # Catalog, search, categories
│   ├── product_detail_page.dart # Product detail with Hero
│   ├── cart_page.dart           # Shopping cart
│   ├── checkout_page.dart      # Checkout form
│   ├── pix_payment_page.dart    # PIX QR code generation
│   └── order_success_page.dart # Order confirmed
├── providers/
│   ├── cart_provider.dart       # Cart state + persistence
│   └── catalog_provider.dart    # Catalog loading + filters
├── theme/
│   └── app_theme.dart           # Coastal design system
├── utils/
│   └── fake_pix.dart            # PIX EMV payload + CRC16
└── widgets/
    ├── product_card.dart        # Product card with hover + Hero
    ├── benefits_bar.dart        # Shipping/free delivery bar
    ├── currency.dart            # BRL currency formatter
    └── site_footer.dart         # Footer widget
```

---

## State Management — Provider

The app uses **Provider** (ChangeNotifier pattern) for all state:

### CartProvider
- Manages cart items, total items, and total price
- Persists to SharedPreferences on every mutation
- Restores cart on `init()` via `SharedPreferences.getString`
- Methods: `addProduct`, `increment`, `decrement`, `removeProduct`, `clear`

### CatalogProvider
- Loads products from `ProductRepository` on startup
- Maintains selected category and search query
- `filtered` getter combines category + text search
- `categories` getter extracts unique categories from loaded products

### Provider Setup

Both providers are registered at app startup via `MultiProvider` in `main.dart`:

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => CartProvider()..init()),
    ChangeNotifierProvider(
      create: (_) => CatalogProvider(DemoProductRepository())..load(),
    ),
  ],
  child: const ModaPraiaApp(),
);
```

---

## Data Layer & Repository Pattern

```
ProductRepository (abstract)
       │
       └── DemoProductRepository (implements)
              │
              └── Static list of 10 Products
```

The `ProductRepository` abstract class defines a single method:
```dart
Future<List<Product>> getProducts();
```

Today, `DemoProductRepository` provides a static catalog. Tomorrow, a Firebase or REST API implementation can be plugged in without touching any UI code.

---

## Models

### Product
- Fields: `id`, `name`, `description`, `price`, `category`, `imageAsset`, `isFeatured`
- Includes `toJson()` and `fromJson()` for serialization
- `isFeatured` defaults to `false`

### CartItem
- Wraps a `Product` with a mutable `quantity`
- Computed `total` property: `product.price * quantity`

### Order
- Fields: `id`, `items`, `total`, `customerName`, `address`, `paymentMethod`, `createdAt`
- Immutable value object created at checkout

---

## Pages & Navigation

Standard `Navigator.push/pop` routing (no named routes or router):

| Page | Purpose |
|---|---|
| `HomePage` | Hero banner, search, categories, product grid |
| `ProductDetailPage` | Full product detail with Hero transition |
| `CartPage` | Cart items, quantity controls, total, proceed to checkout |
| `CheckoutPage` | Customer info form |
| `PixPaymentPage` | Generated PIX QR code + copy-paste code |
| `OrderSuccessPage` | Confirmation with order summary |

All transitions use `MaterialPageRoute` with Hero animations between product list and detail.

---

## Responsive Layout

The `HomePage` adapts its product grid based on screen width:

| Width | Columns | Aspect Ratio |
|---|---|---|
| < 600px | 2 | 0.68 |
| 600–899px | 3 | 0.74 |
| 900–1199px | 4 | 0.80 |
| >= 1200px | 5 | 0.80 |

The hero banner also scales: 230px on mobile, 360px on desktop (>= 900px).

---

## Theme & Design System

`AppTheme` defines a coastal color palette:

| Token | Hex | Usage |
|---|---|---|
| `deep` | #0A3D5C | Primary dark, gradients |
| `sea` | #0E7490 | Primary, buttons, links |
| `aqua` | #2CA6A4 | Secondary accent |
| `sand` | #F6F1E7 | Background |
| `gold` | #C9A24B | CTAs, badges, featured |
| `ink` | #15202B | Text, icons |

Two gradient constants: `seaGradient` (AppBar hero) and `goldGradient` (CTAs).

Material 3 is enabled with custom card, button, chip, input, and text themes.

---

## PIX Payment Simulation

`FakePix` generates EMV/BR Code compliant payloads with:

- **Merchant Account**: TLV field 26 with `demo@modapraiasantos.com.br` (non-existent PIX key)
- **Transaction ID**: Unique per order
- **Currency**: BRL (986)
- **CRC16-CCITT**: Correctly calculated for QR scan compatibility

> **Security**: The demo key doesn't exist at any bank, so no real payment can be processed.

---

## Persistence

`CartProvider` persists cart state using `SharedPreferences`:
- Key: `moda_praia_cart_v1`
- Format: JSON array of `{product: {...}, quantity: N}`
- Restored on app init, corrupted data silently ignored

---

## CI/CD Pipeline

### CI (`ci.yml`)
Triggers on push to `master` and PRs:
1. `flutter pub get`
2. `flutter analyze --no-fatal-infos --no-fatal-warnings`
3. `flutter test`

### Deploy (`deploy-web.yml`)
Triggers on push to `master`:
1. `flutter build web --release --base-href=/flutter_ecommerce/`
2. Upload artifact to GitHub Pages
3. Deploy via `actions/deploy-pages@v4`

---

## Design Decisions

### Why Provider instead of GetX/Bloc?
Provider is simpler and has less boilerplate. For a single-page catalog app, ChangeNotifier provides sufficient reactivity without the complexity of streams or GetX routing.

### Why Navigator.push instead of GoRouter/GetX routing?
The app has a flat navigation structure (6 pages, no deep linking). Standard `MaterialPageRoute` keeps the implementation simple and maintains Hero animations.

### Why FakePix instead of a real payment SDK?
This is a portfolio project. A realistic-looking PIX QR code (with correct EMV structure) showcases technical skill without requiring API keys, compliance, or payment processing.

### Why persist cart in SharedPreferences?
Web apps lose state on refresh. SharedPreferences (via shared_preferences package) provides a simple key-value store that works across Flutter platforms, ensuring cart survives page reloads.

---

*Update this document when significant architectural changes are made.*
