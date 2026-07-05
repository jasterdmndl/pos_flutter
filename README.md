# Mire Sunset POS 🌅☕

**Mire Sunset** is a premium, boutique Point-of-Sale (POS) system designed for high-end hospitality environments. Built with Flutter, it offers a world-class, offline-first experience with near-instant cloud synchronization.

---

## ✨ Design Identity: "The Modern Glasshouse"
The system utilizes a bespoke **Boutique Emerald Design System** characterized by:
*   **Solid Emerald Aesthetic**: High-contrast Forest Greens (#006B2C) and Ink (#1A1C19) with zero generic gradients.
*   **Signature Typography**: Characterful `Fraunces` serif for headlines paired with technical `Space Grotesk` for data.
*   **Architectural Depth**: 1.5px high-contrast borders and solid hard shadows for a premium, structured look.
*   **Organic Motion**: Fluid, staggered entrance animations and tactical micro-interactions.

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

### ⚖️ BIR EOPT Legal Compliance
*   **Unified Invoicing**: 100% compliant with **Republic Act No. 11976**, issuing professional "Sales Invoices."
*   **Tax Engine**: Automatic 12% VAT calculations and VAT-Exempt handling for SC/PWD/Student privileges.
*   **Z-Reading**: Mandatory end-of-day mechanism with a non-resettable cloud-synced Reset Counter.
*   **Audit Trail**: Immutable sales data enforced via PostgreSQL triggers and Isar local persistence.

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

*“Speed, Simplicity, and Character — Designed for the Modern Cafe.”* 🌿☕
