# Mire Sunset Flows 🌅☕

> Step-by-step flows for the offline-first POS. See `DATABASE.md` for tables and `SETUP_GUIDE.md:59` for RLS/SQL.

All diagrams are Mermaid (rendered on GitHub).

---

## 1) Login + Single Session per Account

15s watcher at `lib/features/auth/session_watcher.dart:33` via `app_navigator.dart` + `profiles.active_session_id`.

```mermaid
sequenceDiagram
    participant U as User
    participant S as LoginScreen (login_screen.dart:235)
    participant A as AuthNotifier (auth_provider.dart:115)
    participant DB as Supabase Postgres
    participant W as SessionWatcher (15s)

    U->>S: Enter email + password (eye at login_screen.dart:332)
    S->>A: login(email, password)
    A->>DB: auth.signInWithPassword()
    DB-->>A: user.id (auth.uid)
    A->>DB: SELECT * FROM profiles WHERE id = user.id
    DB-->>A: role (admin/owner/cashier)
    A->>A: local Isar put UserEntity + state = localUser
    A->>DB: UPDATE profiles SET active_session_id = new UUID WHERE id = user.id
    A-->>S: success
    S->>S: pushReplacement to PosScreen or MobileOwnerDashboard
    loop every 15s
        W->>DB: SELECT active_session_id FROM profiles WHERE id = auth.uid()
        alt remote != local _sessionId
            W->>A: forceLogout() (clear state + auth.signOut)
            W->>S: appNavigatorKey pushAndRemoveUntil LoginScreen + banner forceLogoutReasonProvider
        end
    end
```

Offline path: `auth_provider.dart:115` falls back to `_tryOfflineLogin` → Isar `UserEntity` compare `passwordHash`; still triggers `catalogSyncProvider` pull when back online.

---

## 2) Sale — Offline-First (Cash / GCash / Card manual)

Core cart at `lib/features/cart/`, checkout at `lib/features/checkout/`, Isar `OrderEntity` at `lib/core/database/collections/order_entity.dart:6`.

```mermaid
sequenceDiagram
    participant C as Cashier
    participant POS as PosScreen
    participant Cart as CartProvider
    participant Isar as Isar (OrderEntity isSynced=false)
    participant Print as printing/pdf

    C->>POS: Tap product → add to cart (customizations as product_addons)
    POS->>Cart: increaseQuantity / remove
    Cart-->>POS: total / vatable / VAT / exempt
    C->>POS: Checkout → select payment (cash/gcash/card manual) → confirm
    POS->>Isar: writeTxn put OrderEntity + OrderItemEntity + OrderAddonEntity
    Isar-->>POS: receiptNumber (OR-YYYY-###### at order_entity.dart:36)
    POS->>Print: pdf + qr
    POS-->>C: Receipt shown, cart cleared
    Note over Isar: Queued for sync (isSynced=false, @Index at order_entity.dart:28)
```

---

## 3) Order Sync — Cross-Device (5 min + on login)

`SyncRepository.syncPendingOrders()` at `lib/features/sync/sync_repository.dart:13`, `SyncProvider` 5 min timer at `lib/features/sync/sync_provider.dart`, pull at `sync_repository.dart:136`.

```mermaid
sequenceDiagram
    participant D1 as Device A (Admin)
    participant I1 as Isar A
    participant SB as Supabase (orders/order_items/order_item_addons)
    participant D2 as Device B
    participant I2 as Isar B
    participant SP as SyncProvider (5m)

    D1->>I1: Sale saved isSynced=false
    loop every 5 min + on login
        SP->>I1: filter isSynced==false
        SP->>SB: upsert orders → upsert order_items → upsert order_item_addons
        SP->>I1: writeTxn isSynced=true
    end
    D2->>SB: pullCashierOrders(cashierId, 90d) at auth_provider.dart:115
    SB-->>D2: SELECT orders WHERE cashier_id=auth.uid() AND created_at >= since
    D2->>SB: SELECT order_items WHERE order_id IN (...) + order_item_addons
    D2->>I2: put OrderEntity (id = global get_next_invoice_id) + items/addons, isSynced=true (never re-uploaded)
    D2-->>D2: invalidate dashboardProvider + salesHistoryProvider
```

BIR note: `get_next_invoice_id()` sequence + triggers block `UPDATE` of finalized invoices (see `SETUP_GUIDE.md:59`).

---

## 4) Catalog Sync — Shared Menu (30s, full including ingredients)

`CatalogSyncRepository` at `lib/features/sync/catalog_sync_repository.dart:13` (uuid `syncId`), `CatalogSyncProvider` 30s at `lib/main.dart` + `lib/features/sync/catalog_sync_provider.dart`, name-merge at `catalog_sync_repository.dart:205`.

```mermaid
sequenceDiagram
    participant Adm as Admin Device
    participant PR as ProductRepository (product_repository.dart:41)
    participant CR as CatalogSyncRepository
    participant SB as Supabase (categories/products/product_addons/ingredients/product_ingredients)
    participant Oth as Other Device
    participant CP as CatalogSyncProvider (30s)

    Adm->>PR: saveProduct(name, price, categoryId)
    PR->>CR: upsertCategory(category) first (ensure syncId)
    PR->>PR: product.categorySyncId = category.syncId
    CR->>SB: upsert categories/products/... (id = syncId, soft-delete = false)
    PR->>PR: Isar put (now with syncId)
    loop every 30s + on login
        Oth->>CP: pullCatalog()
        CP->>SB: SELECT * FROM 5 catalog tables
        CP->>CP: categories → ingredients → products (resolve categorySyncId→localId via catSyncToLocal) → addons → product_ingredients (resolve via prod/ing maps)
        Note over CP: If syncId miss, merge by name (e.g. seeded "Coffee"); if cloud is_deleted and no local → skip (avoids LateInitializationError)
        CP->>CP: invalidate productProvider + categoriesProvider + addonProvider
    end
    Oth-->>Oth: POS grid shows new product
```

Soft-delete: `deleteProduct()` at `product_repository.dart:41` sets local `isDeleted=true` + `softDelete('products', syncId)` → cloud `is_deleted=true` → other devices mark local `isDeleted=true` and filter out at `lib/features/products/product_provider.dart` / `addon_provider.dart` / `inventory_screen.dart`.

---

## 5) Z-Reading / Reports (BIR Daily Close)

`lib/features/reports/z_reading_repository.dart` + `running_totals`, `ZReadingEntity` at `lib/core/database/collections/z_reading_entity.dart:7`.

```mermaid
sequenceDiagram
    participant Mgr as Owner/Admin
    participant R as ZReadingRepository
    participant Isar as Isar
    participant SB as Supabase

    Mgr->>R: Close Day
    R->>Isar: sum gross/net/VAT/discounts, first/last invoice, count, resetCounter++
    R->>Isar: put ZReadingEntity (isSynced=false)
    R->>SB: upsert z_readings + running_totals
    R->>Isar: isSynced=true
```

---

## 6) Inventory Deduction (per sale)

`lib/features/inventory/inventory_repository.dart:7` — recipes `product_ingredients` define `amount_used` per `productId`.

```mermaid
sequenceDiagram
    participant Sale as Checkout
    participant Inv as InventoryRepository
    participant Isar as Isar

    Sale->>Inv: deductInventory(productId, qty)
    Inv->>Isar: filter product_ingredients where productId
    loop each recipe
        Inv->>Isar: get IngredientEntity, stockQuantity -= amount_used * qty, put
    end
    Note over Isar: Stock stays local — pulled catalog syncs definition (name/unit) only at catalog_sync_repository.dart:256
```

---

See `DATABASE.md` for table schemas and `README.md` for client handover. For setup, follow `SETUP_GUIDE.md`.
