---
name: Emerald POS
colors:
  surface: '#f4fcf0'
  surface-dim: '#d5dcd1'
  surface-bright: '#f4fcf0'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eff6ea'
  surface-container: '#e9f0e5'
  surface-container-high: '#e3eadf'
  surface-container-highest: '#dde5d9'
  on-surface: '#171d16'
  on-surface-variant: '#3e4a3d'
  inverse-surface: '#2b322b'
  inverse-on-surface: '#ecf3e7'
  outline: '#6e7b6c'
  outline-variant: '#bdcaba'
  surface-tint: '#006e2d'
  primary: '#006b2c'
  on-primary: '#ffffff'
  primary-container: '#00873a'
  on-primary-container: '#f7fff2'
  inverse-primary: '#62df7d'
  secondary: '#006d30'
  on-secondary: '#ffffff'
  secondary-container: '#92f5a4'
  on-secondary-container: '#007233'
  tertiary: '#a72d51'
  on-tertiary: '#ffffff'
  tertiary-container: '#c74668'
  on-tertiary-container: '#fffbff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#7ffc97'
  primary-fixed-dim: '#62df7d'
  on-primary-fixed: '#002109'
  on-primary-fixed-variant: '#005320'
  secondary-fixed: '#95f8a7'
  secondary-fixed-dim: '#79db8d'
  on-secondary-fixed: '#00210a'
  on-secondary-fixed-variant: '#005323'
  tertiary-fixed: '#ffd9de'
  tertiary-fixed-dim: '#ffb2bf'
  on-tertiary-fixed: '#3f0016'
  on-tertiary-fixed-variant: '#8a143c'
  background: '#f4fcf0'
  on-background: '#171d16'
  surface-variant: '#dde5d9'
typography:
  display-lg:
    fontFamily: Geist
    fontSize: 48px
    fontWeight: '700'
    lineHeight: '1.1'
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Geist
    fontSize: 32px
    fontWeight: '600'
    lineHeight: '1.2'
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Geist
    fontSize: 24px
    fontWeight: '600'
    lineHeight: '1.3'
  body-lg:
    fontFamily: Geist
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.5'
  body-md:
    fontFamily: Geist
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.5'
  label-lg:
    fontFamily: Geist
    fontSize: 14px
    fontWeight: '600'
    lineHeight: '1.2'
    letterSpacing: 0.05em
  label-md:
    fontFamily: Geist
    fontSize: 12px
    fontWeight: '500'
    lineHeight: '1.2'
  headline-lg-mobile:
    fontFamily: Geist
    fontSize: 24px
    fontWeight: '600'
    lineHeight: '1.2'
  body-lg-mobile:
    fontFamily: Geist
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.4'
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  2xl: 48px
  touch-target-min: 44px
  grid-gutter: 16px
  grid-margin: 24px
---

## Brand & Style

This design system is engineered for high-performance hospitality environments where speed, clarity, and a premium aesthetic are paramount. The brand personality is **Professional, Efficient, and Organic**, reflecting a commitment to fresh quality through a "Green" identity.

The visual style draws inspiration from **Corporate Modernism**—specifically the utility of Square and the refined precision of Stripe. It utilizes a high-contrast layout, generous white space, and a focus on functional aesthetics. The UI is designed to be **touch-first**, ensuring that baristas and servers can navigate complex orders with zero friction. The aesthetic response should feel like a "calm tool"—powerful enough for rush hour but visually quiet enough to stay out of the way.

## Colors

The palette is anchored by a functional green hierarchy, moving from a deep, authoritative Forest Green for primary actions to a vibrant Mint for accents and state changes.

- **Primary (#16A34A):** Used for the most important "Commit" actions like "Pay" or "Confirm Order."
- **Secondary/Dark (#15803D):** Reserved for active states, pressed buttons, and high-level navigation headers.
- **Accent (#22C55E):** Used for notifications, active status indicators, and success states.
- **Surface & Background:** High-value neutrals ensure that food photography and product colors pop without distraction.

In **Dark Mode**, the interface shifts to a deep navy foundation to reduce eye strain in low-light evening environments (bars/late-night cafes), while the Primary Green shifts to a brighter tint (#22C55E) to maintain AA/AAA accessibility against dark backgrounds.

## Typography

This design system utilizes **Geist** for its technical precision and exceptional legibility at both large display sizes and small label sizes.

- **Hierarchy:** High contrast is achieved through weight rather than just size. Headlines use SemiBold (600) and Bold (700) to anchor the eye quickly.
- **Numerical Data:** As a POS system, prices and quantities are treated with display-level priority. Use `headline-md` for price points on buttons to ensure they are glanceable from a distance.
- **Touch Targets:** Typography is never cramped. Line heights are generous (1.5 for body) to ensure that text blocks remain readable during fast-paced movement.

## Layout & Spacing

The layout utilizes a **Fixed Grid** model for tablets (typically the primary POS hardware) and a **Fluid Grid** for mobile/handheld devices.

- **Grid System:** A 12-column grid is used for desktop/tablet. Product tiles usually span 2 or 3 columns depending on density requirements.
- **Touch-First Spacing:** No interactive element should be smaller than `touch-target-min` (44px).
- **Rhythm:** A 4px/8px incremental system ensures vertical rhythm. Most containers use `lg` (24px) padding to provide a premium, airy feel.
- **Responsive Reflow:** On handheld devices, the sidebar (receipt) collapses into a bottom sheet or a separate "View Cart" view to maximize the product selection area.

## Elevation & Depth

To maintain a clean, modern look inspired by Linear, depth is communicated through **Tonal Layers** and extremely subtle **Ambient Shadows**.

- **Level 0 (Background):** The base layer (#F8FAFC) creates a foundation.
- **Level 1 (Surface):** Card containers and main navigation panels are pure white (#FFFFFF). They feature a 1px border (#E2E8F0) to define edges.
- **Level 2 (Interaction):** Hover states or "picked up" items use a soft shadow: `0 4px 12px rgba(15, 23, 42, 0.08)`.
- **Level 3 (Modals):** Overlays and pop-outs use a more pronounced shadow: `0 12px 32px rgba(15, 23, 42, 0.12)`.

Avoid heavy gradients. Depth should feel architectural, not decorative.

## Shapes

The design system uses a **Rounded** corner philosophy (8px/0.5rem base) to strike a balance between professional rigor and approachable friendliness.

- **Standard Elements (Buttons, Inputs):** 8px radius.
- **Large Containers (Cards, Modals):** 16px (rounded-lg) to soften the large screen real estate.
- **Product Tiles:** 12px (between standard and large) to give them a distinct, "touchable" appearance.
- **Chips/Status Tags:** Always 100px (Pill-shaped) to distinguish them from interactive buttons.

## Components

### Buttons
- **Primary:** Background Primary Green, Text White. Solid fill.
- **Secondary:** Background Light Green (#DCFCE7), Text Dark Green (#15803D). No border.
- **Ghost:** No background, Text Primary Neutral, 1px border on hover.
- **Sizing:** Minimum height 48px for touch efficiency.

### Product Cards (Tiles)
- Minimalist design. Image takes top 60%, followed by Title (Bold) and Price (Regular) at the bottom. 
- Use a 1px inner border rather than a drop shadow for an "organized" feel.

### Input Fields
- Background is Surface White. 
- Border is #E2E8F0. 
- Focus state: 2px border #16A34A with a 4px soft green outer glow.

### Order List (The "Receipt")
- Items are separated by subtle horizontal dividers. 
- High-contrast typography for the "Total" amount at the bottom.
- Swipe-to-delete gestures for mobile handhelds; "X" buttons for fixed tablets.

### Chips & Badges
- Used for "In Stock", "Out of Stock", or "Table Number".
- Small, uppercase Geist font (`label-md`).