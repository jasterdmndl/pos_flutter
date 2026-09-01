# Mire Sunset POS 🌅☕

A high-performance Point-of-Sale system built for speed, security, and the Philippine cafe workflow. Built with **Flutter**, **Isar**, and **Supabase**.

---

## For the Business Owner

**Mire Sunset** is an offline-first POS for a single-branch cafe. It runs on Windows Desktop (maximized, native controls) and Android Tablets from one codebase.

*   **Sell without internet:** Every sale is saved instantly on the device and syncs when online.
*   **One menu everywhere:** Add or edit a product/category/addon/ingredient on one device — it appears on all devices within ~30 seconds.
*   **Three roles:** Owner and Admin see everything (POS + Dashboard + Management + Reports). Cashier is locked to POS/Cart/Checkout only.
*   **Single session per account:** If the same account logs in on another device, the previous device is signed out — prevents shared-login misuse.
*   **Payments:** Cash, GCash (manual reference), and Card (manual reference) — no gateway required for v1.
*   **BIR-ready foundation:** Database triggers block tampering of finalized invoices; Z-Reading / running totals are built in.

## System Components (What Runs Where)

| Layer | Technology | What it does for you |
|-------|------------|----------------------|
| **Frontend** | Flutter 3.12 (`pubspec.yaml`) | One codebase for Windows + Android Tablet. Fast, text-only product grid for rapid tapping. |
| **State** | Riverpod 2.6.1 | Keeps cart, checkout, and product data consistent across screens. |
| **Local Database** | Isar 3.1.0+1 (`lib/core/database/isar_service.dart`) | High-speed on-device NoSQL. Stores products, orders, and pending sync queue. Zero-lag even offline. |
| **Cloud Database** | Supabase — PostgreSQL (`lib/core/services/supabase_service.dart`) | Central database for orders, catalog, and auth. Enables cross-device sync via Row Level Security (RLS). |
| **Sync Engine** | Background pollers (`lib/features/sync/`) | Orders sync every ~5 min + on login; catalog syncs every ~30s. Soft-delete propagates deletes. |

**Hosting model:** The cloud database lives in **your own Supabase project** (owned by you, not the developer). The app installers (APK/EXE) connect to it via your `SUPABASE_URL`/`SUPABASE_ANON_KEY` in `.env`. Without that project, each device works only locally — no sync.

---

## ⚡ Key Highlights for the Shop Floor

### 🖥️ Fast POS Terminal
*   **Zero-Lag Grid**: Optimized product cards for rapid tapping.
*   **1-Tap GCash**: Auto-generates unique reference numbers.
*   **Always Maximized**: Windows launches fullscreen with native minimize/exit.
*   **Visual Health Check**: Header badge (Green/Orange/Red) shows sync/connection status.

### 🛡️ Built-In Security
*   **Role Guards**: Cashier locked to POS. Dashboard/Management require Admin/Owner (`lib/features/auth/auth_provider.dart`).
*   **BIR Compliance**: DB triggers prevent deletion/alteration of finalized invoices.
*   **Input Protection**: Validates product names/prices (no 0-price accidents).
*   **Single Session**: `profiles.active_session_id` + 15s watcher prevents concurrent logins.

### 📶 Bulletproof Sync (Offline-First)
*   **Sell Without Internet**: Saved to Isar instantly.
*   **Smart Recovery**: Exponential backoff on sync failures.
*   **Catalog Sync**: Categories, products, addons, ingredients, and recipes sync across all devices.

---

## What You Receive

*   **Installers:** Windows installer (MSIX/EXE via `msix_config` in `pubspec.yaml`) + Android APK (`flutter build apk --split-per-abi`).
*   **Source Repository:** Full `pos_flutter` repo (Flutter + Isar + Supabase) — handed over to you.
*   **Cloud Setup:** Supabase project under your account with 8 tables + RLS + `is_admin_or_owner()` function + `get_next_invoice_id()` sequence. You own the data.
*   **Credentials:** `.env` with your `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `GCASH_NUMBER`, `EMERGENCY_ADMIN_*`.
*   **Docs:** `SETUP_GUIDE.md` + `docs/` handover.

---

## 🛠️ The Tech "Engine"

*   **Frontend**: Flutter (Windows Maximized / Android Tablet).
*   **Local DB**: Isar (indexed on `createdAt`/`isSynced`/`syncId` for fast history + sync).
*   **Cloud DB**: Supabase Postgres — 8 tables: `profiles`, `orders`, `order_items`, `order_item_addons`, `categories`, `products`, `product_addons`, `ingredients`, `product_ingredients`.
*   **State**: Riverpod.
*   **Logging**: `logger` (`pubspec.yaml`) — no `print()` in production.
*   **Other**: `google_fonts`, `flutter_animate`, `fl_chart`, `printing`/`pdf`, `qr_flutter`, `uuid`, `connectivity_plus`.

---

## 🚀 Setup & Deployment Handbook

### 🔑 Environment Configuration
Create a `.env` in the root (required):
```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
GCASH_NUMBER=09xxxxxxxxx
GCASH_NAME=STORE_NAME
EMERGENCY_ADMIN_EMAIL=admin@example.com
EMERGENCY_ADMIN_PASSWORD=secret_code
```

### 🎨 Branding (Windows)
1.  Place logo at `assets/app_icon.png`.
2.  Update `windows/Runner/CMakeLists.txt` (`BINARY_NAME`).
3.  Run:
    ```bash
    dart run flutter_launcher_icons
    ```

### 📦 Building for Production
*   **Windows**: `flutter build windows` (EXE at `build/windows/x64/runner/Release/`).
*   **Android**: `flutter build apk --split-per-abi`.

See `SETUP_GUIDE.md` for full DB + RLS setup and `docs/` for architecture.

---

## 📝 Developer Notes
*   **Sync Logic**: Orders use server-generated `get_next_invoice_id()`; catalog uses client UUID `syncId` + soft-delete (`is_deleted`) with name-merge on pull to avoid duplicate seeded rows (`lib/features/sync/catalog_sync_repository.dart`).
*   **Performance**: Check Isar `@Index` on `createdAt`/`isSynced`/`syncId` if dashboard feels slow.
