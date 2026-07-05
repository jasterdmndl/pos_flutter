# Mire Sunset POS 🌅☕

**Mire Sunset** is a Point-of-Sale (POS) system designed for high-end hospitality environments. Built with Flutter, it offers a world-class, offline-first experience with near-instant cloud synchronization.

---
## 🚀 Professional Features

### 🖥️ POS Terminal (Windows & Tablet)
*   **Smart Product Grid**: Rapid menu navigation with responsive layout and touch-first tiles.
*   **Tactical Cart**: Order merging logic with integrated add-on customization (milks, syrups, extra shots).
*   **Integrated Numpad**: Custom 10-key layout for rapid cash entry without software keyboard delays.
*   **Change Calculator**: Real-time change due and insufficient payment validation.
*   **GCash Integration**: Dynamic QR code generation for instant customer scanning.

### 📱 Owner Monitoring (Mobile)
*   **Live Order Stream**: Near-zero latency feed of transactions ringing up at the terminal.
*   **Remote Analytics**: Pocket access to daily sales, order counts, and top-performing products.
*   **Boutique Mobile UI**: Vertically optimized layout with time-of-day personalized greetings.

---

## 🛠️ Technical Stack
*   **Frontend**: Flutter (Cross-platform support for Windows and Android).
*   **State**: Riverpod (Reactive data flow).
*   **Database**: Isar (High-performance local storage).
*   **Cloud**: Supabase (PostgreSQL, Auth, Real-time streams).
*   **Sync**: Instant cloud push with background fallback queue.

---

## 🔑 Access Control
*   **Admin**: Full access to Terminal, Management, Dashboard, and Z-Reading.
*   **Cashier**: Restricted strictly to the POS terminal interface.
*   **Owner**: Dedicated remote monitoring experience for mobile devices.

---

## 📦 Deployment
*   **Windows**: Professional single-file `.msix` installer.
*   **Android**: Fully optimized `.apk` for tablets and phones.
*   **Security**: All credentials managed securely via `.env` environment variables.

---
