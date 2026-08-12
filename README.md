# 🛒 SAP RAP Sales Order Management System

An end-to-end **SAP ABAP RESTful Application Programming Model (RAP)**
application for managing Sales Orders, Customers, Products, Invoices and
Payments through a modern **SAP Fiori Elements** user interface.

This project demonstrates practical RAP development using CDS data
modeling, behavior definitions, EML, validations, determinations,
actions, value helps, feature control and Fiori Elements.

## 🎯 Project Overview

The application manages the Sales Order process:

``` text
Customer
   │
   ▼
Sales Order Header
   │
   └── Sales Order Items
          │
          └── Product / Stock
   │
   ├── Invoice
   └── Payment
```

## 🛠️ Technology Stack

  Layer              Technology
  ------------------ --------------------------------------------------
  Backend            SAP BTP ABAP Environment / ABAP Platform
  Framework          ABAP RESTful Application Programming Model (RAP)
  Data Modeling      ABAP Core Data Services (CDS)
  Business Logic     ABAP OO + Entity Manipulation Language (EML)
  UI                 SAP Fiori Elements
  Service            OData
  Development Tool   Eclipse / ABAP Development Tools (ADT)
  Database           SAP HANA
  UI Configuration   Metadata Extensions (DDLX)

## ✨ Key Features

### Sales Order Management

Sales Order Header includes:

-   Sales Order ID
-   Customer
-   Order Date
-   Delivery Date
-   Currency
-   Total Amount
-   Net Amount
-   Paid Amount
-   Balance Amount
-   Status

Sales Order Items include:

-   Item Number
-   Product
-   Quantity
-   Unit Price
-   Amount

### Customer and Product Management

Customer master data includes Customer ID, Customer Name, Email, Phone,
City, State, Country, Postal Code and Status.

Product data includes Product ID, Product Name, Category, Brand, Unit
Price, Currency and Available Stock.

The Sales Order Header provides a **Customer value help**, and Sales
Order Items provide a **Product value help**.

### Sales Order Actions

The RAP behavior implements business actions including:

-   Approve
-   Reject
-   Cancel
-   Dispatch
-   Generate Invoice
-   Record Payment

### Validations

The project contains business validations such as:

-   Order Date validation
-   Delivery Date validation
-   Stock validation
-   Mandatory field validation

Example stock validation:

``` text
Available Stock = 50
Requested Qty   = 70

70 > 50
   ↓
❌ Insufficient stock
```

### Determinations

Business logic includes determinations for:

-   Calculate GST
-   Calculate Total Amount
-   Set Initial Status
-   Auto Approve Status

### Early Numbering

Product IDs use early numbering, for example:

``` text
PRD000001
PRD000002
PRD000003
```

## 🏗️ RAP Architecture


┌─────────────────────────────────────────────┐
│              SAP Fiori Elements             │
│          List Report / Object Page          │
└──────────────────────┬──────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────┐
│              OData Service                  │
│       Service Definition / Binding          │
└──────────────────────┬──────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────┐
│              RAP Business Object            │
│                                             │
│ Sales Order Header → Sales Order Items      │
│                                             │
│ Actions / Validations / Determinations      │
└──────────────────────┬──────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────┐
│          CDS Interface / Projection         │
│                                             │
│       ZAP_I_*  →  ZAP_C_*                  │
└──────────────────────┬──────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────┐
│             Database Tables                 │
│ Customer | Product | Sales Order | Invoice │
│ Payment  | Sales Order Item                  │
└─────────────────────────────────────────────┘
```

## 🔄 Sales Order Lifecycle

``` text
New
 │
 ▼
Pending Approval
 │
 ├──────────────► Rejected
 │
 ▼
Approved
 │
 ▼
Dispatched
 │
 ▼
Invoice Generated
 │
 ▼
Payment Recorded
```

Cancellation and action availability are controlled by the implemented
RAP business rules and feature control.

## 📐 CDS Data Flow

``` text
Database Table
      ↓
Interface CDS View
      ↓
Projection CDS View
      ↓
Behavior Definition
      ↓
Service Definition
      ↓
Service Binding
      ↓
Fiori Elements
```

## 🧠 RAP Behavior

``` text
CRUD
 │
 ├── Create
 ├── Update
 └── Delete

Actions
 │
 ├── Approve
 ├── Reject
 ├── Cancel
 ├── Dispatch
 ├── Generate Invoice
 └── Record Payment

Validations
 │
 ├── Validate Stock
 ├── Validate Delivery Date
 └── Other business validations

Determinations
 │
 ├── Calculate GST
 ├── Calculate Total Amount
 ├── Set Initial Status
 └── Auto Approve Status
```

## 🎨 Fiori Elements

The UI provides:

-   List Report
-   Object Page
-   Sales Order Header
-   Sales Order Items
-   Customer value help
-   Product value help
-   Business action buttons
-   Validation messages
-   Draft/edit processing where configured

## 📊 Business Process

``` text
                 ┌──────────────┐
                 │   Customer   │
                 └──────┬───────┘
                        │
                        ▼
              ┌───────────────────┐
              │   Sales Order     │
              │      Header       │
              └─────────┬─────────┘
                        │
                        ▼
              ┌───────────────────┐
              │   Sales Order     │
              │      Items        │
              └─────────┬─────────┘
                        │
                ┌───────┴────────┐
                ▼                ▼
        ┌──────────────┐   ┌──────────────┐
        │   Product    │   │ Stock Check  │
        └──────────────┘   └──────┬───────┘
                                  │
                                  ▼
                         ┌────────────────┐
                         │ Approval Flow  │
                         └───────┬────────┘
                                 │
                                 ▼
                         ┌────────────────┐
                         │   Dispatch     │
                         └───────┬────────┘
                                 │
                                 ▼
                         ┌────────────────┐
                         │    Invoice     │
                         └───────┬────────┘
                                 │
                                 ▼
                         ┌────────────────┐
                         │    Payment     │
                         └────────────────┘
```

## 📸 Screenshots

Create a `docs/images` folder and upload your real screenshots there:

``` text
docs/images/
├── sales-order-list.png
├── sales-order-object-page.png
├── customer-value-help.png
├── product-value-help.png
├── stock-validation.png
├── delivery-date-validation.png
└── sales-order-actions.png
```

Then embed them in the README, for example:

``` markdown
![Sales Order Object Page](docs/images/sales-order-object-page.png)
```

## 📂 Repository Structure

 
YOUR-REPOSITORY/
│
├── src/
├── docs/
│   └── images/
│
└── README.md


Keep the `src` folders aligned with the actual structure already present
in your repository.

## 🚀 How to Run / Preview

1.  Open the project in Eclipse with ABAP Development Tools.
2.  Activate CDS views and behavior definitions.
3.  Activate behavior implementation classes.
4.  Activate the Service Definition.
5.  Publish the Service Binding.
6.  Open the Fiori Elements preview.
7.  Test Customer and Product value helps.
8.  Create a Sales Order.
9.  Add Sales Order Items.
10. Test validations and business actions.

## 📚 Skills Demonstrated

-   ABAP RESTful Application Programming Model (RAP)
-   CDS View Entities
-   Interface and Projection Views
-   Behavior Definitions
-   Behavior Implementation Classes
-   Managed RAP
-   Draft-enabled processing where configured
-   Early Numbering
-   Entity Manipulation Language (EML)
-   RAP Validations
-   RAP Determinations
-   RAP Actions
-   Instance Feature Control
-   Value Helps
-   Associations
-   Compositions
-   Metadata Extensions
-   OData Services
-   SAP Fiori Elements
-   SAP HANA persistence
-   SAP BTP ABAP Environment / ABAP Platform

## 💼 Portfolio Highlights

**Project:** SAP RAP Sales Order Management System

**Role:** SAP ABAP / RAP Developer

Key implementation work:

-   Designed CDS-based Sales Order business objects.
-   Implemented RAP transactional processing.
-   Developed Sales Order business actions.
-   Implemented stock and date validations.
-   Implemented early numbering.
-   Created Customer and Product value helps.
-   Built Fiori Elements List Report and Object Page experience.
-   Implemented business status and feature-control logic.
-   Exposed the application through an OData service binding.

## 👨‍💻 Author

**\[https://github.com/adii988]**

SAP ABAP | RAP | CDS | Fiori Elements | SAP BTP

------------------------------------------------------------------------

This repository is a learning and implementation showcase of an
end-to-end SAP RAP Sales Order Management application.
# ZAP_SALES_RAP
Sales Order Management System 
