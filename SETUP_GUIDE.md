# 🚀 POS Flutter Setup & Architecture Guide

Welcome to **Mire Sunset POS** — an offline-first Point of Sale for a single-branch cafe. This guide covers architecture and setup for a new environment.

## 🏗 Project Architecture

Layered, offline-first. UI → Riverpod → Business Logic → Isar (local) → Sync Services → Supabase (cloud).

### Technology Stack
*   **Frontend**: Flutter 3.12 (Windows Desktop + Android Tablet) — `pubspec.yaml:31`
*   **State Management**: Riverpod 2.6.1 (`pubspec.yaml:34`)
*   **Local Database**: Isar 3.1.0+1 (`lib/core/database/isar_service.dart`) — `Isar.autoIncrement` + `syncId` UUID for cross-device sync
*   **Cloud Backend**: Supabase 2.15.0 (`pubspec.yaml:47`) — PostgreSQL + GoTrue Auth + PostgREST + Realtime
*   **Compliance**: BIR triggers + `get_next_invoice_id()` + Z-Reading (`lib/features/reports/z_reading_repository.dart`)
*   **Other**: `google_fonts`, `flutter_animate`, `fl_chart`, `printing`/`pdf`, `qr_flutter`, `uuid`, `logger`, `connectivity_plus`, `window_manager`

---

## 📂 Folder Structure

```text
lib/
├── core/               # Shared logic, themes, global services
│   ├── database/       # Isar collections (category/product/ingredient/product_ingredient/product_addon/order/*) + isar_service.dart
│   ├── services/       # supabase_service.dart, connectivity
│   ├── navigation/     # app_navigator.dart (global key for forced navigation)
│   ├── theme/          # AppTheme
│   └── utils/          # logger, error_handler
├── features/           # Modular features
│   ├── auth/           # login_screen.dart, auth_provider.dart, session_watcher.dart (15s), user_repository.dart
│   ├── pos/            # POS interface + product selection
│   ├── cart/           # cart logic
│   ├── checkout/       # payment + inventory deduction
│   ├── dashboard/      # sales analytics
│   ├── inventory/      # stock + ingredients
│   ├── products/       # product/category/addon management + product_provider.dart
│   └── sync/           # sync_repository.dart (orders), catalog_sync_repository.dart + catalog_sync_provider.dart (30s)
└── main.dart           # ProviderScope + PosFlutterApp (watches session + catalog sync)
```

---

## 🛠 Setup Instructions

### 1. Prerequisites
*   Flutter SDK (Stable, ^3.12.2 at `pubspec.yaml:22`)
*   Git, Android Studio / VS Code
*   **Windows Desktop**: Visual Studio 2022 with "Desktop development with C++"

### 2. Environment Configuration
Create `.env` in the root. **Required.**

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
GCASH_NUMBER=09xxxxxxxxx
GCASH_NAME=STORE_NAME
EMERGENCY_ADMIN_EMAIL=admin@example.com
EMERGENCY_ADMIN_PASSWORD=your-password
```

### 3. Database Initialization (Supabase)

Create these 8 tables (all in `public`):

*   `profiles` (id uuid PK = auth uid, username, role, `active_session_id text` for single-session)
*   `orders` (id bigint PK via `get_next_invoice_id()`, total, cashier_id, `is_synced`, etc.)
*   `order_items` (id, order_id, product_id, quantity, etc.)
*   `order_item_addons`
*   `categories` (id uuid PK `syncId`, name unique, is_active, updated_at, is_deleted)
*   `products` (id uuid PK `syncId`, name, price, category_sync_id FK, is_active, updated_at, is_deleted)
*   `product_addons` (id uuid PK, name, price, is_per_unit, is_active, updated_at, is_deleted)
*   `ingredients` (id uuid PK, name, stock_quantity, unit, updated_at, is_deleted)
*   `product_ingredients` (id uuid PK, product_sync_id FK, ingredient_sync_id FK, amount_used, updated_at, is_deleted)
*   `running_totals`, `z_readings` for reports

**RLS & Functions — required for orders + catalog sync + single-session:**

```sql
-- Helper (SECURITY DEFINER so it reads profiles despite RLS)
create or replace function public.is_admin_or_owner()
returns boolean language sql security definer set search_path = public as $$
  select exists (select 1 from public.profiles where id = auth.uid() and role in ('admin','owner'));
$$;

-- Enable RLS
alter table profiles enable row level security;
alter table categories enable row level security;
alter table products enable row level security;
alter table product_addons enable row level security;
alter table ingredients enable row level security;
alter table product_ingredients enable row level security;

-- profiles: self + admin/owner can manage
-- categories/products/product_addons/ingredients/product_ingredients:
--   SELECT to authenticated using (true)
--   ALL to authenticated using/with check (is_admin_or_owner())
-- Also ensure get_next_invoice_id() exists for orders.
```
Local Isar collections (`category/product/product_addon/ingredient/product_ingredient` at `lib/core/database/collections/`) include `syncId` (UUID, `@Index(unique: true)`), `updatedAt`, `isDeleted`, plus `categorySyncId/productSyncId/ingredientSyncId` to resolve cross-references by sync id (not local int).

### 4. Build Commands
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs  # regenerates Isar *.g.dart
flutter run
flutter build windows          # EXE at build/windows/x64/runner/Release/
flutter build apk --split-per-abi
dart run flutter_launcher_icons  # from assets/app_icon.png
```

---

## 🔄 Sync Logic Explained

1.  **Offline**: Sale → Isar `OrderEntity` (`isSynced == false`).
2.  **Orders**: `SyncRepository.syncPendingOrders()` → `upsert` to Supabase; `SyncProvider` every 5 min + on login (`lib/features/auth/auth_provider.dart:115`). Cross-device pull via `pullCashierOrders(cashierId)` (90-day lookback).
3.  **Catalog**: `CatalogSyncRepository` (`lib/features/sync/catalog_sync_repository.dart`) — Admin edits push via `upsert*` keyed by `syncId` (UUID). `CatalogSyncProvider` pulls every 30s (`lib/main.dart` watches it) and merges by `syncId` then `name` to avoid duplicate seeded rows; `is_deleted` soft-delete propagates.
4.  **Single Session**: On login, `AuthNotifier` writes `profiles.active_session_id` (UUID). `SessionWatcher` (`lib/features/auth/session_watcher.dart`) polls 15s; mismatched `active_session_id` triggers `forceLogout()` + `appNavigatorKey` navigation + banner on login.
5.  **Completion**: After cloud confirms items/addons, local `isSynced = true`; soft-deleted catalog rows are filtered in `product_provider.dart`/`addon_provider.dart`.

---

## 👤 Role-Based Access (RBAC)
*   **Admin/Owner**: Everything (POS + Dashboard + Management + Reports + Staff). Can write catalog (RLS `is_admin_or_owner()`).
*   **Cashier**: POS/Cart/Checkout + own Sales History (void hidden). Guest (no `supabaseUserId`) is cashier-equivalent, offline only.

---

## 📝 Maintenance
*   **Local DB**: Windows `Documents/default.isar`, Android internal storage. Isar schema change is additive (auto-migrated, no `version` param needed in 3.1).
*   **Resetting**: Truncate Supabase tables + delete local `.isar` (+ uninstall to clear).
