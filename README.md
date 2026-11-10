# J'Donuts

A Flutter donut-shop mobile application featuring simulated phone
authentication, local product data, product browsing, product details,
and a display-only rewards interface.

## 1. Requirements and Versions

-   **Flutter:** 3.38.5
-   **Dart:** 3.10.4
-   **Database:** Drift 2.31.0 (SQLite)
-   **State management:** Riverpod
-   **Navigation:** GoRouter

You will need the Flutter SDK, Android Studio and/or Xcode, and an
Android emulator, iOS simulator, or physical device.

## 2. How to Run

Clone the repository and open the project directory:

``` bash
git clone https://github.com/phyotd/j_donuts.git
cd j_donuts
```

Install dependencies:

``` bash
flutter pub get
```

Generate the Drift database code:

``` bash
dart run build_runner build --force-jit --delete-conflicting-outputs
```

Check the project:

``` bash
flutter analyze
```

Run the app:

``` bash
flutter run
```

## 3. Architecture

The project uses a **feature-first, layered architecture inspired by
Clean Architecture**. Features are separated into data, domain, and
presentation layers.

-   **Data layer:** Mock data, local data sources, models, mappers, and
    repository implementations.
-   **Domain layer:** Entities and repository contracts.
-   **Presentation layer:** Screens, reusable widgets, and Riverpod
    providers.

### Folder Map

``` text
lib/
├── app/
│   ├── router/
│   └── theme/
├── core/
│   ├── database/
│   └── utils/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── screens/
│   │       └── widgets/
│   ├── products/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── mappers/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── screens/
│   │       └── widgets/
│   └── home/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart

assets/
└── images/
    ├── banners/
    └── donuts/
```

The folder map shows the main project structure; individual feature
folders may contain additional files.

## 4. State Management

The app uses **Riverpod** for state management and dependency injection.

Riverpod providers are used to: 
-   Share application dependencies, including the Drift database.
-   Expose product data to the presentation layer.
-   Manage and expose authentication-related state.
-   Keep UI code
    separate from data access and business logic.

## 5. Offline Strategy

The current app uses local data and bundled assets rather than requiring
a remote backend.

-   **Drift (SQLite):** Stores user and product records locally.
-   **Mock product data:** Seeds the local product database.
-   **Bundled images:** Product and banner images are loaded from
    Flutter assets using `Image.asset`.
-   **Local-first browsing:** Product lists and product details can be
    displayed without making network requests.

The current implementation does not use internet reachability checks
because the main product experience does not depend on a server.

## 6. Animations and UI Interactions

-   **Hero animation:** Transitions the product image between a product
    card and its product detail screen. Hero tags are made unique for
    products shown in different Home sections.
-   **Banner carousel:** Uses `PageView` to let users swipe between
    promotional banners.
-   **Carousel indicators:** Uses `AnimatedContainer` to animate the
    active page indicator.
-   **Quantity selector:** Updates the displayed total price when the
    quantity changes.

## 7. Demo OTP

The authentication flow uses a simulated OTP and does not send a real
SMS.

**Demo OTP:** `123456`

Use the code above when testing the OTP verification flow. If the value
configured in the current source code is different, update this section
to match it.

## 8. Main Implemented Features

-   Phone number entry and simulated OTP verification.
-   New-user registration with first name, optional last name, and date
    of birth.
-   Local user data storage with Drift.
-   Session-related storage using Flutter Secure Storage.
-   Home screen with member information and a promotional banner
    carousel.
-   Seasonal Specials, Popular Donuts, and All Donuts horizontal
    product sections.
-   Product cards with NEW and data-driven discount badges.
-   Product detail screen with product information and quantity
    selection.
-   Live total-price calculation.
-   Rewards screen showing membership information and points.

## 9. Known Gaps

-   OTP verification is simulated; no real SMS provider is connected.
-   There is no production authentication service or remote API
    integration.
-   Product and promotional content currently come from local mock data.
-   Rewards is display-only; points redemption and transaction history
    are not implemented.
-   Add-to-cart feedback is not a complete persistent cart or checkout
    flow.

## 10. Time Spent

**Total time spent:** 1.5 days

