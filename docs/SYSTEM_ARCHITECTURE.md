# Mire Sunset ☕

Offline-First Cafe Point of Sale — Flutter, Riverpod, Isar, Supabase (single-branch, Owner/Admin/Cashier).

---

## Overview

Priorities: fast cashier workflow, offline reliability, real cafe customization, cloud sync, single session per account.

Platforms: Windows Desktop (`window_manager` at `pubspec.yaml:56`) + Android Tablets (Flutter 3.12, `pubspec.yaml:22`).

---

## Tech Stack

### Frontend
Flutter 3.12 (`pubspec.yaml:31`)

### State Management
Riverpod 2.6.1 (`pubspec.yaml:34`)

### Local Database
Isar 3.1.0+1 (`pubspec.yaml:39`) — `lib/core/database/isar_service.dart`; collections at `lib/core/database/collections/` with `syncId`/`updatedAt`/`isDeleted` + `categorySyncId/productSyncId/ingredientSyncId`.

### Cloud Backend
Supabase 2.15.0 (`pubspec.yaml:47`) — PostgreSQL (`lib/core/services/supabase_service.dart:5`) + GoTrue Auth + PostgREST.

---

## Features

*   **Product Management:** Catalog + categories + pricing; cross-device via `catalog_sync_repository.dart` (UUID `syncId`, soft-delete, name-merge for seeded duplicates).
*   **Cart:** add/increase/decrease/remove, auto-total.
*   **Customization:** Oat/Soy/extra shot/syrup pumps + future modifiers.
*   **Discounts:** Senior/PWD 20%.
*   **Payments:** Cash / GCash (manual ref) / Card (manual ref).
*   **Offline First + Single Session:** Transactions saved locally → cloud; `SessionWatcher` 15s (`lib/features/auth/session_watcher.dart:33`) via `profiles.active_session_id` + `appNavigatorKey` (`lib/core/navigation/app_navigator.dart`).

---

## Project Structure

```text
lib/
├── core/
│   ├── database/  # isar_service.dart, collections/*.dart (*.g.dart generated)
│   ├── services/  # supabase_service.dart
│   ├── navigation/# app_navigator.dart
│   ├── theme/     # AppTheme
│   └── utils/     # logger, error_handler
├── features/
│   ├── auth/      # login_screen.dart, auth_provider.dart, session_watcher.dart
│   ├── products/  # management + product_provider.dart / addon_provider.dart
│   ├── cart/      # cart_* 
│   ├── checkout/  # checkout_controller.dart
│   ├── inventory/ # inventory_screen/repository
│   ├── dashboard/ # dashboard_screen/repository
│   ├── orders/    # order_repository
│   ├── reports/   # z_reading_repository
│   └── sync/      # sync_repository/provider (orders, 5m) + catalog_sync_repository/provider (catalog, 30s)
└── main.dart      # ProviderScope, watches sessionWatcherProvider + catalogSyncProvider
```

---

## Architecture

```text
Flutter UI
  ↓
Riverpod (productProvider at lib/features/products/product_provider.dart, addonProvider, authProvider)
  ↓
Business Logic (product_repository.dart:41 save/upsert + soft-delete; inventory_repository.dart)
  ↓
Isar Database (local id + syncId resolution)
  ↓
Sync Services
  ├─ orders: SyncRepository (upsert orders/order_items/order_item_addons)
  ├─ catalog: CatalogSyncRepository (upsert categories/products/product_addons/ingredients/product_ingredients; pull merges by syncId→name)
  └─ session: SessionWatcher (15s)
  ↓
Supabase Postgres + RLS (is_admin_or_owner() SECURITY DEFINER; SELECT to authenticated, ALL with check is_admin_or_owner())
  — owned by client; installers connect via .env
```

---

## Business Rules

*   Quantity-based cart: `Latte x3` (correct) vs three rows (incorrect).
*   Customizations with different add-ons remain separate entries (`Latte+Oat` ≠ `Latte+Soy`).
*   Soft-deleted catalog rows filtered in `product_provider.dart` / `addon_provider.dart` / `inventory_screen.dart`.

---

## Hosting & Delivery

*   Supabase project under **client's account** (8 tables + `active_session_id` + RLS). Repo handed over.
*   Installers: `flutter build windows` + `flutter build apk --split-per-abi`; icons via `flutter_launcher_icons.yaml` (`assets/app_icon.png`); Windows name via `windows/Runner/CMakeLists.txt`.

---

## License

Under active development for commercial deployment (single-branch cafe).
