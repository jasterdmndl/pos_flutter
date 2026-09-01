# Mire Sunset - Project Overview

## Project Information

### Project Name
Mire Sunset

### Project Type
Offline-First Point of Sale (POS) System

### Target Business
Single-Branch Cafe / Coffee Shop (1 store, Owner/Admin/Cashier roles)

### Platforms
* Windows Desktop (maximized, `window_manager` at `pubspec.yaml:56`)
* Android Tablets
* Single codebase via Flutter 3.12 (`pubspec.yaml:22`)

---

# Executive Summary

Mire Sunset is a modern offline-first POS for small/medium cafes, prioritizing cashier speed and real-world beverage workflows (milk substitutions, syrup pumps, extra shots). It works fully offline via Isar (`lib/core/database/isar_service.dart`) and syncs to Supabase Postgres when online (`lib/features/sync/`). One menu is shared across all devices.

---

# Business Objectives

*   Improve cashier efficiency
*   Reduce ordering errors
*   Support drink customization
*   Operate without internet
*   Synchronize sales + catalog to cloud
*   Generate sales reports / Z-Reading (`lib/features/reports/z_reading_repository.dart`)
*   Scalable foundation (repo handed over to client)

---

# Core Features

## Product Ordering & Catalog Sync

Cashiers browse/add/increase/decrease/remove products. **Cross-device catalog sync** (`lib/features/sync/catalog_sync_repository.dart` + 30s `catalog_sync_provider.dart`): an Admin adding a product/category/addon/ingredient on one device appears on all devices. Soft-delete propagates. Stock quantity sync is definition-only (local stock stays operational).

## Product Customizations

Latte + Oat Milk (+₱15), Vanilla Syrup x3 (+₱15), Extra Shot (+₱20) — handled as `product_addons` and `product_ingredients`.

## Quantity-Based Cart

Groups identical products: `Latte x3` (not three separate rows) — faster workflow.

## Discounts

Senior Citizen 20%, PWD 20%.

## Payment Methods

Cash, GCash (manual reference), Card (manual reference) — no gateway required for v1.

## Offline First + Single Session

Sale → Isar → Receipt → Queued → Supabase (`isSynced`). `SessionWatcher` (`lib/features/auth/session_watcher.dart:33`) enforces single session per account via `profiles.active_session_id` (15s poll + `appNavigatorKey` at `lib/core/navigation/app_navigator.dart`).

---

# Technology Stack

## Frontend
Flutter 3.12 (`pubspec.yaml:31`) — Windows + Android Tablet.

## State Management
Riverpod 2.6.1 (`pubspec.yaml:34`) — cart/checkout/product/sync state.

## Local Database
Isar 3.1.0+1 (`pubspec.yaml:39`) — `Isar.autoIncrement` local id + `syncId` UUID (`@Index(unique: true)`), `updatedAt`, `isDeleted`, `categorySyncId/productSyncId/ingredientSyncId` for cross-device resolution. Stores products/orders/pending sync.

## Cloud Backend
Supabase 2.15.0 (`pubspec.yaml:47`) — PostgreSQL, GoTrue Auth, PostgREST, Realtime. 8 tables: `profiles` (+ `active_session_id`), `orders`/`order_items`/`order_item_addons`, `categories`/`products`/`product_addons`/`ingredients`/`product_ingredients`, plus `running_totals`/`z_readings`. RLS via `is_admin_or_owner()` SECURITY DEFINER; anon key via `supabase_service.dart:5`.

## Other
`google_fonts`, `flutter_animate`, `fl_chart`, `printing`/`pdf`, `qr_flutter`, `uuid` (`pubspec.yaml:57`), `logger`, `connectivity_plus`, `window_manager`.

---

# Software Architecture

Flutter UI
↓
Riverpod State Management
↓
Business Logic Layer
↓
Isar Database (`lib/core/database/collections/`) — plus `syncId` resolution
↓
Synchronization Service (`lib/features/sync/` — orders 5m, catalog 30s, session 15s)
↓
Supabase Cloud (Postgres + RLS) — owned by client

---

# Database Design

## Categories / Products / Addons / Ingredients / Product-Ingredients

All catalog tables share `id uuid PK (= syncId)`, `name`, `updated_at`, `is_deleted` (+ type-specific fields `price/is_active/category_sync_id`). Product-ingredient links use `product_sync_id`/`ingredient_sync_id`.

## Orders / Order Items / Order Item Addons

`orders` id via `get_next_invoice_id()` (BIR sequence), `total/cashier_id/is_synced`.

---

# Business Rules

*   Tap existing product → quantity increments (`Latte x1 → x2`); minus to zero removes.
*   Different customizations remain separate cart entries (`Latte+Oat` ≠ `Latte+Soy`).

---

# Hosting & Delivery

*   **Cloud DB** lives in **your own Supabase project** (you own data). Installers (APK at `build/` + Windows EXE/MSIX via `msix_config` at `pubspec.yaml:83`) connect via your `.env` (`SUPABASE_URL`/`ANON_KEY` at `README.md`). Without it, each device is local-only.
*   **Repo handed over:** Full `pos_flutter` repo included.

---

# Current Development Status

Completed:
*   Flutter/Riverpod/Cart/Quantity/Remove/Total/Product Grid/Cart Panel/Add-ons/Checkout/Discounts/Isar/Receipt/Supabase sync/Reporting/Product Management (CRUD)/Inventory/Single-session/Cross-device catalog sync (full, incl. ingredients) & RLS hardening

In Progress:
*   Production Deployment Testing (peripheral spike, UAT)

---

# Project Vision

Reliable, modern POS tailored for coffee shops — offline-reliable, single-menu everywhere, scalable for future phases.
