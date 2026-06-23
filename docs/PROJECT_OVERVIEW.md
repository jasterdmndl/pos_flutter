# Cafe POS System - Project Overview

## Project Information

### Project Name

Cafe POS System

### Project Type

Offline-First Point of Sale (POS) System

### Target Business

Single-Branch Cafe / Coffee Shop

### Platforms

* Windows Desktop
* Android Tablets
* Future Mobile Support

---

# Executive Summary

The Cafe POS System is a modern offline-first point-of-sale solution specifically designed for small and medium-sized cafes. The system prioritizes cashier speed, reliability, and real-world coffee shop workflows while remaining simple enough for daily operations.

Unlike traditional retail POS systems, this solution supports beverage customizations such as milk substitutions, syrup pumps, and additional espresso shots.

The application functions completely offline and synchronizes data to the cloud whenever an internet connection becomes available.

---

# Business Objectives

The system aims to:

* Improve cashier efficiency
* Reduce ordering errors
* Support drink customization workflows
* Operate without internet connectivity
* Synchronize sales data to the cloud
* Generate sales reports
* Provide a scalable foundation for future growth

---

# Core Features

## Product Ordering

Cashiers can:

* Browse products
* Add products to cart
* Increase quantity
* Decrease quantity
* Remove products

Example:

Latte x2
Mocha x1

---

## Product Customizations

Supports real cafe modifications.

Examples:

Latte

* Oat Milk (+₱15)

Latte

* Vanilla Syrup x3 (+₱15)

Latte

* Extra Shot (+₱20)

---

## Quantity-Based Cart

The system groups identical products.

Example:

Incorrect:

Latte
Latte
Latte

Correct:

Latte x3

Benefits:

* Cleaner interface
* Faster cashier workflow
* Easier order management

---

## Discounts

Supported Discounts:

* Senior Citizen (20%)
* PWD (20%)

Future discount structures can be added.

---

## Payment Methods

Supported Methods:

* Cash
* GCash

No third-party payment integration required.

---

## Offline First Architecture

Sales are processed locally first.

Workflow:

Sale Created
↓
Saved to Isar
↓
Receipt Generated
↓
Queued for Sync
↓
Uploaded to Supabase

Internet connection is never required to complete a sale.

---

# Technology Stack

## Frontend

Flutter

Benefits:

* Single codebase
* High performance
* Cross-platform support

---

## State Management

Riverpod

Used for:

* Cart state
* Checkout state
* Product state
* Synchronization state

---

## Local Database

Isar Database

Stores:

* Products
* Orders
* Order Items
* Add-ons
* Pending Sync Data

---

## Cloud Backend

Supabase

Services:

* PostgreSQL Database
* Cloud Backup
* Reporting Database
* Future Authentication

---

# Software Architecture

Flutter UI
↓
Riverpod State Management
↓
Business Logic Layer
↓
Isar Database
↓
Synchronization Service
↓
Supabase Cloud

---

# Database Design

## Products

products

* id
* name
* price
* category_id
* is_active

---

## Categories

categories

* id
* name

---

## Product Add-ons

product_addons

* id
* name
* price_type
* price

Examples:

* Oat Milk (+15)
* Soy Milk (+10)
* Vanilla Syrup (+5 per pump)
* Extra Shot (+20)

---

## Orders

orders

* id
* subtotal
* discount_amount
* total
* payment_method
* created_at
* sync_status

---

## Order Items

order_items

* id
* order_id
* product_id
* quantity
* base_price
* subtotal

---

## Order Item Add-ons

order_item_addons

* id
* order_item_id
* addon_id
* quantity
* price
* subtotal

---

# Business Rules

## Quantity Handling

If product already exists:

Latte x1
↓
Tap Latte
↓
Latte x2

---

## Quantity Reaches Zero

Latte x1
↓
Press Minus
↓
Removed from Cart

---

## Customizations

Products with different customizations must remain separate.

Example:

Latte + Oat Milk
Latte + Soy Milk

These remain separate cart entries.

---

# Future Modules

* Receipt Printing
* Sales Reporting
* Daily Closing Reports
* Product Management
* Cloud Dashboard
* Inventory Tracking (Optional Future Phase)

---

# Current Development Status

Completed:

* Flutter Setup
* Riverpod Setup
* Product Models
* Product Providers
* Cart Models
* Cart Controller
* Add Product Logic
* Quantity Management
* Remove Item Logic
* Cart Total Calculation
* Product Grid UI
* Cart Panel UI

In Progress:

* Product Add-ons
* Checkout Flow
* Discounts
* Isar Integration
* Receipt Printing
* Supabase Synchronization

---

# Project Vision

To provide a reliable, modern, and easy-to-use POS solution specifically tailored for coffee shop operations while maintaining offline reliability and future scalability.
