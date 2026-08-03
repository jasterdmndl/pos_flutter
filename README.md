# Mire Sunset POS 🌅☕

A high-performance Point-of-Sale system built for speed, security, and the Philippine retail market (BIR-ready). Built with **Flutter**, **Isar**, and **Supabase**.

---

## ⚡ Key Highlights for the Shop Floor

### 🖥️ Fast POS Terminal
*   **Zero-Lag Grid**: Optimized, text-only product cards designed for rapid tapping.
*   **1-Tap GCash**: Automatically generates unique reference numbers—no more manual typing for cashiers.
*   **Always Maximized**: Launches in fullscreen on Windows with native minimize/exit controls restored for ease of use.
*   **Visual Health Check**: A color-coded badge (Green/Orange/Red) in the header tells staff instantly if the Wi-Fi is down or if data is waiting to sync.

### 🛡️ Built-In Security
*   **Role Guards**: Cashiers are strictly locked into the POS screen. Dashboard and Settings require **Admin** or **Owner** privileges.
*   **BIR Compliance**: Database triggers prevent manual tampering, deletion, or illegal alteration of finalized invoices.
*   **Input Protection**: Prevents "ghost" items by validating product names and prices (no more 0-price accidents).

### 📶 Bulletproof Sync (Offline-First)
*   **Sell Without Internet**: Take orders 100% offline. Data is saved instantly to the local **Isar** database.
*   **Smart Recovery**: Uses **Exponential Backoff**—if the internet drops, the app waits politely before retrying to avoid crashing the router or server.

---

## 🛠️ The Tech "Engine"
*   **Frontend**: Flutter (Windows Maximized / Android Tablet).
*   **Local DB**: Isar (High-speed indexing for fast sales history searches).
*   **Cloud DB**: Supabase (Real-time order streams for the Owner app).
*   **State**: Riverpod (Ensures data stays consistent across screens).
*   **Logging**: Professional `logger` integrated—no more messy `print()` statements in production.

---

## 🚀 Setup & Deployment Handbook

### 🔑 Environment Configuration
Create a `.env` file in the root directory:
```env
SUPABASE_URL=your_project_url
SUPABASE_ANON_KEY=your_anon_key
GCASH_NUMBER=09xxxxxxxxx
GCASH_NAME=STORE_NAME
EMERGENCY_ADMIN_EMAIL=admin@example.com
EMERGENCY_ADMIN_PASSWORD=secret_code
```

### 🎨 Branding (Windows)
1.  Place your logo at `assets/app_icon.png`.
2.  Update the Windows executable name in `windows/Runner/CMakeLists.txt` (look for `BINARY_NAME`).
3.  Run the icon generator:
    ```bash
    dart run flutter_launcher_icons
    ```

### 📦 Building for Production
*   **Windows**: `flutter build windows` (generates the .exe in the build folder).
*   **Android**: `flutter build apk --split-per-abi` (optimizes for tablet performance).

---

## 📝 Developer Notes
*   **Sync Logic**: We use `insert()` instead of `upsert()` to comply with BIR database triggers that block record updates.
*   **Performance**: If the dashboard feels slow, check the Isar `@Index` annotations on `createdAt` and `isSynced`.
