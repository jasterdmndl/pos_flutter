# Mire Sunset ☕

Offline-First Cafe Point of Sale System built with Flutter, Riverpod, Isar, and Supabase.

---

## Overview

Mire Sunset is a modern POS solution designed specifically for small cafe businesses.

The system prioritizes:

* Fast cashier workflow
* Offline reliability
* Real cafe customization logic
* Cloud synchronization
* Cross-platform deployment

Supported Platforms:

* Windows Desktop
* Android Tablets

---

## Tech Stack

### Frontend

* Flutter

### State Management

* Riverpod

### Local Database

* Isar

### Cloud Backend

* Supabase (PostgreSQL)

---

## Features

### Product Management

* Product Catalog
* Categories
* Product Pricing

### Cart Management

* Add Product
* Increase Quantity
* Decrease Quantity
* Remove Product
* Automatic Total Calculation

### Product Customization

Supports:

* Oat Milk
* Soy Milk
* Extra Espresso Shot
* Syrup Pumps
* Future Modifiers

### Discounts

* Senior Citizen
* PWD

### Payments

* Cash
* GCash

### Offline First

All transactions are saved locally first and synchronized to the cloud later.

---

## Project Structure

lib/

core/

features/

├── products/

├── cart/

├── checkout/

├── discounts/

├── orders/

├── reports/

└── sync/

services/

main.dart

---

## Architecture

Flutter UI
↓
Riverpod
↓
Business Logic
↓
Isar Database
↓
Sync Service
↓
Supabase

---

## Current Progress

Completed

* Flutter Setup
* Riverpod Setup
* Product Model
* Product Provider
* Cart Item Model
* Cart Controller
* Quantity Management
* Remove Item Logic
* Cart Total Calculation
* Product Grid
* Cart Panel

Upcoming

* Product Add-ons
* Checkout
* Discounts
* Isar Database
* Receipt Printing
* Supabase Sync
* Reporting Dashboard

---

## Business Rules

### Quantity-Based Cart

Correct:

Latte x3

Incorrect:

Latte
Latte
Latte

### Customization Handling

Products with different add-ons remain separate.

Example:

Latte + Oat Milk

Latte + Soy Milk

These are treated as separate cart entries.

---

## License

This project is currently under active development and intended for commercial deployment.
