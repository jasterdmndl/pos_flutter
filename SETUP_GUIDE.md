# 🚀 POS Flutter Setup & Architecture Guide

Welcome to the **POS Flutter** project. This document provides a complete overview of the codebase and instructions for setting it up on a new environment.

## 🏗 Project Architecture

This is an **Offline-First** Point of Sale system built with Flutter. It uses a layered architecture to separate business logic from the UI.

### Technology Stack
*   **Frontend**: Flutter (Mobile & Desktop support)
*   **State Management**: Riverpod (Functional and reactive)
*   **Local Database**: Isar (High-performance NoSQL for offline storage)
*   **Cloud Backend**: Supabase (Authentication, PostgreSQL, and Real-time sync)
*   **Compliance**: Built-in BIR compliance triggers and invoice sequencing.

---

## 📂 Folder Structure

```text
lib/
├── core/               # Shared logic, themes, and global services
│   ├── database/       # Isar collections and initialization
│   ├── services/       # Supabase and Connectivity services
│   ├── theme/          # Global AppTheme and styling
│   └── utils/          # Loggers and error handlers
├── features/           # Modular feature folders
│   ├── auth/           # Login, Role-based access, and Staff Management
│   ├── pos/            # Point of Sale interface and product selection
│   ├── cart/           # Cart logic and calculations
│   ├── checkout/       # Payment processing and inventory deduction
│   ├── dashboard/      # Sales analytics (Local & Remote)
│   ├── inventory/      # Stock management and ingredients
│   └── sync/           # Background synchronization logic
└── main.dart           # App entry point and initialization
```

---

## 🛠 Setup Instructions

### 1. Prerequisites
*   Flutter SDK (Stable channel)
*   Git
*   Android Studio / VS Code
*   **Windows Desktop**: Visual Studio 2022 with "Desktop development with C++" workload.

### 2. Environment Configuration
Create a `.env` file in the root directory. **This file is required for the app to start.**

```env
SUPABASE_URL=https://your-project-url.supabase.co
SUPABASE_ANON_KEY=your-anon-key
EMERGENCY_ADMIN_EMAIL=admin@example.com
EMERGENCY_ADMIN_PASSWORD=your-password
```

### 3. Database Initialization (Supabase)
Ensure your Supabase project has the following tables:
*   `profiles` (id, username, role)
*   `orders` (id, total, cashier_id, etc.)
*   `order_items`
*   `order_item_addons`

**Important**: Apply the RLS policies and the `get_next_invoice_id()` function provided in the project documentation to ensure sync works.

### 4. Build Commands
Run these in the project terminal:

```bash
# 1. Get dependencies
flutter pub get

# 2. Generate Isar database code
dart run build_runner build --delete-conflicting-outputs

# 3. Run the app
flutter run
```

---

## 🔄 Sync Logic Explained
1.  **Offline**: Sales are saved immediately to **Isar** (`OrderEntity`).
2.  **Background**: The `SyncRepository` scans for `isSynced == false`.
3.  **Cloud**: Data is `upserted` to Supabase.
4.  **Completion**: Once the items and addons are confirmed in the cloud, the local record is marked `isSynced = true`.

---

## 👤 Role-Based Access (RBAC)
*   **Admin/Owner**: Access to everything, including remote dashboards.
*   **Cashier**: Limited to POS, Cart, and Checkout. Access to Management is blocked.

---

## 📝 Maintenance
*   **Local DB Location**: 
    *   Windows: `Documents/default.isar`
    *   Android: Internal App Storage
*   **Resetting**: To clear the system, truncate Supabase tables and delete the local `.isar` files.
