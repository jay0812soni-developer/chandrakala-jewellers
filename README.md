# ✨ ChandraKala Jewellers - Mobile & Web App

A modern, high-performance, cross-platform luxury jewellery shopping and live bullion rate tracking application built with **Flutter (Dart 3.x)**, **BLoC Architecture**, and **Vercel Serverless Backend** backed by **PostgreSQL**.

---

## 🌟 Key Features

- **Live Gold & Silver Bullion Ticker**: Instant real-time rate tracking (24K, 22K 916 Hallmark, Silver 999) with real-time refresh, market trends, and offline fallback.
- **Synchronous Pricing Engine**: Accurate, transparent pricing calculated dynamically:
  $$\text{Final Price} = (\text{Net Weight} \times \text{Live Rate}) + \text{Wastage/VA} + \text{Making Charges} + 3\% \text{ GST}$$
- **Interactive Jewellery Gallery & Showcase**: High-res categorized jewellery catalogue (Necklaces, Bangles, Rings, Mangalsutra, Silverware) with pinch-to-zoom (`PhotoView`) and luxury shimmering placeholders.
- **Zero-Lag 60/120 FPS Rendering**:
  - `RepaintBoundary` wrappers on all jewellery grid items to prevent dirty canvas repainting during scroll.
  - Cached downscaled image memory buffers (`memCacheWidth: 400`) to preserve GPU RAM.
- **Robust BLoC State Management**:
  - Dedicated BLoCs for `RatesBloc`, `GalleryBloc`, `CatalogueBloc`, `CartBloc`, and `AuthBloc`.
  - Comprehensive `BlocListener` / `BlocConsumer` integration for all notifications, snackbars, and side-effects.
  - Structured `AppLogger` integration across every state transition, event dispatch, and error.
- **Cart & Reservation System**:
  - 24-hour stock lock support via serverless row-level locking.
  - Instant direct checkout with Razorpay and WhatsApp concierge order placement.
- **Offline First**: Seamless repository fallbacks ensuring fluid browsing and UI continuity even without an active internet connection.

---

## 🏗️ Architecture & Clean Directory Layout

The frontend follows feature-first clean architecture:

```
frontend/
├── .github/workflows/ci.yml       # Automated GitHub Actions CI (analyze, format, test, build)
├── lib/
│   ├── core/                      # Global singletons, constants, and utilities
│   │   ├── bloc/                  # AppBlocObserver with pretty-printed logger
│   │   ├── network/               # Dio HTTP client, interceptors, base configuration
│   │   ├── pricing/               # Synchronous JewelleryPriceEngine
│   │   ├── routes/                # GoRouter navigation paths and transitions
│   │   ├── services/              # LoggerService with structured PrettyPrinter
│   │   └── theme/                 # Material 3 Luxury Gold (#D4AF37) Theme
│   ├── features/                  # Independent feature modules
│   │   ├── auth/                  # Customer login, registration, session persistence
│   │   ├── cart/                  # CartBloc, cart drawer, item count management
│   │   ├── catalogue/             # CatalogueBloc, custom order and design showcase
│   │   ├── checkout/              # Stock locking, Razorpay payment verification
│   │   ├── gallery/               # GalleryBloc, product filtering, infinite grid
│   │   ├── home/                  # Unified home screen, bullion ticker, category quick-access
│   │   ├── product_detail/        # High-res image viewer, weight selector, dynamic bill breakdown
│   │   └── rates/                 # RatesBloc, live market polling, rate cards
│   └── main.dart                  # App bootstrap, BlocProvider setup, AppBlocObserver hook
├── test/                          # Unit, engine, and widget tests
└── pubspec.yaml                   # Dependencies & assets configuration
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.19.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.3.0`)

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/jay0812soni-developer/chandrakala-jewellers.git
   cd chandrakala-jewellers
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   # Run on Chrome/Web
   flutter run -d chrome

   # Run on Android Device / Emulator
   flutter run -d android

   # Run on iOS Simulator
   flutter run -d ios
   ```

4. Run tests:
   ```bash
   flutter test
   ```

5. Build for Production Web:
   ```bash
   flutter build web --release
   ```

---

## ⚡ Vercel CI/CD Pipeline

The GitHub repository is connected directly to Vercel:
- **Automatic Deployments**: Every `git push` to `main` triggers Vercel CI/CD.
- **Build Script (`build.sh`)**: Automatically clones Flutter stable, runs `flutter pub get`, and executes `flutter build web --release` with the production backend API URL.
- **SPA Routing (`vercel.json`)**: Configured with rewrites to route deep URLs directly to `index.html` without 404 errors.
- **Zero Prebuilt Files in Git**: No compiled artifacts are stored in the repo; all builds are dynamically generated in the CI/CD pipeline.

---

## 📱 Tech Stack

| Technology | Purpose |
|---|---|
| **Flutter 3.x & Dart** | Cross-platform framework for Web, Android, iOS |
| **flutter_bloc & bloc** | Predictable state management with event-driven streams |
| **logger** | Pretty-printed structured console logs for debug & production |
| **dio** | Robust HTTP client with automated timeout, retries, and headers |
| **go_router** | Declarative URL-driven navigation & deep linking |
| **cached_network_image** | Smooth hardware-accelerated image caching with downsampling |
| **photo_view** | Pinch-to-zoom high-resolution jewellery preview |
| **shimmer** | Elegant placeholder loading skeletons |

---

## 🔒 Backend & Database

This frontend is powered by the serverless TypeScript backend:
- **Repository**: [jay0812soni-developer/cj-backend](https://github.com/jay0812soni-developer/cj-backend)
- **Database**: PostgreSQL (Neon / Vercel Postgres)
- **Deployment**: Vercel Serverless Functions

---

## 📄 License
All rights reserved © ChandraKala Jewellers.
