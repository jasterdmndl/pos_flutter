# Mire Sunset - Development Roadmap

## Project Status
Current Stage: Phase 7 — Production Deployment
Progress: Final Testing + Handover Prep

---

# Phase 1 - Core POS Foundation
Completed — Flutter/Riverpod/Product/Cart/Quantity/Remove/Total/Grid/Panel

# Phase 2 - Offline Data Layer
Completed — Isar (`lib/core/database/isar_service.dart`) + collections with `syncId`/`isDeleted` + `build_runner`

# Phase 3 - Receipt System
Completed — `printing`/`pdf`/`qr_flutter` (`pubspec.yaml:42`)

# Phase 4 - Cloud Synchronization
Goal: Synchronize data to cloud.
Status: **Completed**
Tasks:
* [x] Supabase 2.15.0 setup (`lib/core/services/supabase_service.dart`)
* [x] Database Design (8 tables + `profiles.active_session_id`)
* [x] Sync Queue (`isSynced` + `SyncRepository`)
* [x] Upload Orders + Order Items/Addons (`sync_repository.dart:66`)
* [x] Cross-device Order Pull (`pullCashierOrders` 90d, 5m + on login `lib/features/auth/auth_provider.dart:115`)
* [x] Catalog Sync — full (categories/products/product_addons/ingredients/product_ingredients) via `catalog_sync_repository.dart` + `catalog_sync_provider.dart` (30s, UUID `syncId`, soft-delete, name-merge)
* [x] Single Session per Account (`session_watcher.dart:33` 15s + `appNavigatorKey` + `forceLogoutReasonProvider`)
* [x] RLS Hardening (`is_admin_or_owner()` SECURITY DEFINER; SELECT to authenticated, ALL with check)

# Phase 5 - Reporting
Goal: Business insights.
Status: **Completed** — Dashboard (`lib/features/dashboard/`), `fl_chart`, Z-Reading (`lib/features/reports/z_reading_repository.dart`), `running_totals`

# Phase 6 - Product Management
Goal: Allow owners to manage products.
Status: **Completed** — `product_repository.dart:41` CRUD + `product_provider.dart`/`addon_provider.dart` + inventory (`lib/features/inventory/`) — with cross-device propagation and soft-delete filtering

---

# Phase 7 - Production Deployment
Goal: Prepare for live operation (1 store, Owner/Admin/Cashier).
Tasks:
* [x] Performance/Stress/Bug Fixing (unique index `category.name`, LateInitialization `name` guard in catalog pull)
* [x] Backup Testing (Supabase project owned by client)
* [x] Receipt Testing
* [x] Cloud Sync Testing (manual Cash/GCash/Card)
* [x] Login UX — password eye (`lib/features/auth/login_screen.dart:332` Stateful)
* [ ] Peripheral Spike (client's thermal printer/drawer/scanner)
* [ ] User Acceptance Testing (UAT) + Handover (repo + installers + `.env` + docs)

Deliverable: Production Release Candidate + Repo Handover

---

# Phase 8 - Future Expansion
Optional:
*   Payment gateway integration (PayMongo/Maya GCash/Card) — currently manual ref
*   Purchase Orders / Supplier Management
*   Customer Loyalty
*   Multi-Branch (`store_id` tenancy)
*   BIR Accreditation (OR sequence beyond `get_next_invoice_id()`)

---

# Success Criteria

Cashier can: Add/modify quantities/customizations/discounts/payment, complete sales offline.
System can: Save locally, print, sync orders + catalog (30s), enforce single session, generate reports.
Business can: Track sales, review reports, operate without internet, share one menu across all devices.

---

# Estimated Development Order

1. Core POS Foundation → 2. Product Add-ons → 3. Checkout → 4. Isar → 5. Receipt → 6. Supabase Sync (orders + catalog + session) → 7. Reporting → 8. Product Management → 9. Production Testing + Handover
