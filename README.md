# 🏥 Hospital Appointment System — SAP ABAP Cloud RAP Unmanaged

![SAP](https://img.shields.io/badge/SAP-0FAAFF?style=for-the-badge&logo=sap&logoColor=white)
![ABAP](https://img.shields.io/badge/ABAP-Cloud-blue?style=for-the-badge)
![RAP](https://img.shields.io/badge/RAP-Unmanaged-orange?style=for-the-badge)
![OData](https://img.shields.io/badge/OData-V4-green?style=for-the-badge)
![Fiori](https://img.shields.io/badge/SAP%20Fiori-Elements-informational?style=for-the-badge)

> A full-stack SAP ABAP Cloud RESTful Application Programming (RAP) project built in **Unmanaged** mode — where every create, update, delete, and save operation is implemented manually, giving complete control over transactional behaviour.

---

## 👤 Author

| Field | Details |
|---|---|
| **Name** | DEEPAK S |
| **Register No.** | 22IT018 |
| **Mentor** | Ajayan C |
| **Package** | `ZCIT_HOSP_IT018` |
| **Naming Convention** | `IT018` suffix on all objects |

---

## 📌 Project Overview

In **Managed RAP**, the framework automatically handles database persistence. In **Unmanaged RAP**, you write all the logic yourself — like driving a manual car instead of an automatic. This project builds a Hospital Appointment Management app with:

- 🗂️ **Appointment Header** — Patient info, doctor assignment, date, fee
- 🩺 **Appointment Slots (Items)** — Time slot, diagnosis, prescription, follow-up

The app is exposed as an **OData V4 Fiori Elements** application with full **Draft** support.

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      DATABASE LAYER                         │
│  ZCIT_APPT_H_IT018 (Header)   ZCIT_APPT_I_IT018 (Item)     │
└────────────────────┬────────────────────────────────────────┘
                     │  select from
┌────────────────────▼────────────────────────────────────────┐
│                   INTERFACE VIEWS (CDS)                     │
│  ZCIT_APPT_HI_IT018 (Root)    ZCIT_APPT_II_IT018 (Child)   │
└────────────────────┬────────────────────────────────────────┘
                     │  projection on
┌────────────────────▼────────────────────────────────────────┐
│                  CONSUMPTION VIEWS (CDS)                    │
│  ZCIT_APPT_HC_IT018 (Header)  ZCIT_APPT_IC_IT018 (Item)    │
└────────────────────┬────────────────────────────────────────┘
                     │  expose
┌────────────────────▼────────────────────────────────────────┐
│                    SERVICE LAYER                            │
│  Service Def: ZCIT_APPT_UI_IT018                           │
│  Service Binding: ZCIT_APPT_BIND_IT018 (OData V4 – UI)     │
└─────────────────────────────────────────────────────────────┘

BEHAVIOR LAYER (Unmanaged)
  ├── ZCL_APPT_UTIL_IT018     ← Singleton buffer utility
  ├── ZBP_APPT_HDR_IT018      ← Header handler (create/update/delete/read)
  ├── ZBP_APPT_ITM_IT018      ← Item handler (update/delete/read)
  └── ZBP_APPT_SAVER_IT018    ← Saver class (writes to DB on Save)
```

---

## 📁 File Structure

```
ZCIT_HOSP_IT018/
│
├── 📂 Dictionary
│   ├── 📄 ZSAPPT                      Domain – Appointment ID (CHAR 10)
│   ├── 📄 ZCIT_APPT_H_IT018           DB Table – Appointment Header
│   ├── 📄 ZCIT_APPT_I_IT018           DB Table – Appointment Item / Slot
│   ├── 📄 ZCIT_APPT_HDR_D_IT018       Draft Table – Header
│   └── 📄 ZCIT_APPT_ITM_D_IT018       Draft Table – Item
│
├── 📂 CDS Views – Interface
│   ├── 📄 ZCIT_APPT_HI_IT018          Root Interface View (Header)
│   └── 📄 ZCIT_APPT_II_IT018          Child Interface View (Item)
│
├── 📂 CDS Views – Consumption
│   ├── 📄 ZCIT_APPT_HC_IT018          Header Consumption View
│   └── 📄 ZCIT_APPT_IC_IT018          Item Consumption View
│
├── 📂 Metadata Extensions
│   ├── 📄 ZCIT_APPT_HC_IT018          UI Labels & Facets – Header
│   └── 📄 ZCIT_APPT_IC_IT018          UI Labels & Facets – Item
│
├── 📂 Behavior
│   ├── 📄 ZCIT_APPT_HI_IT018          Behavior Definition (Unmanaged)
│   └── 📄 ZCIT_APPT_HC_IT018          Projection Behavior Definition
│
├── 📂 Classes
│   ├── 📄 ZCL_APPT_UTIL_IT018         Utility / Buffer Singleton Class
│   ├── 📄 ZBP_APPT_HDR_IT018          Header Behavior Handler
│   ├── 📄 ZBP_APPT_ITM_IT018          Item Behavior Handler
│   └── 📄 ZBP_APPT_SAVER_IT018        Behavior Saver Class
│
└── 📂 Service
    ├── 📄 ZCIT_APPT_UI_IT018          Service Definition
    └── 📄 ZCIT_APPT_BIND_IT018        Service Binding (OData V4 – UI)
```

---

## 🗄️ Database Tables

### Header Table — `ZCIT_APPT_H_IT018`

| Field | Type | Description |
|---|---|---|
| `APPOINTMENTID` | `ZSAPPT` (CHAR 10) | 🔑 Primary Key |
| `PATIENTNAME` | CHAR 60 | Patient full name |
| `PATIENTAGE` | INT2 | Patient age |
| `GENDER` | CHAR 10 | Gender |
| `CONTACTNUMBER` | CHAR 15 | Phone number |
| `DOCTORNAME` | CHAR 60 | Assigned doctor |
| `DEPARTMENT` | CHAR 40 | Medical department |
| `APPOINTMENTDATE` | DATS | Appointment date |
| `APPOINTMENTSTATUS` | CHAR 20 | Scheduled / Completed / Cancelled |
| `CONSULTATIONFEE` | CURR 13,2 | Fee amount |
| `CURRENCY` | CUKY | Currency code |
| `LOCAL_CREATED_BY/AT` | Admin fields | RAP audit fields |
| `LOCAL_LAST_CHANGED_BY/AT` | Admin fields | RAP audit fields |

### Item Table — `ZCIT_APPT_I_IT018`

| Field | Type | Description |
|---|---|---|
| `APPOINTMENTID` | `ZSAPPT` | 🔑 FK → Header |
| `SLOTNUMBER` | INT2 | 🔑 Slot number |
| `SLOTTIME` | TIMS | Time of slot |
| `DIAGNOSIS` | CHAR 100 | Doctor's diagnosis |
| `PRESCRIPTION` | CHAR 200 | Prescribed medicines |
| `FOLLOWUPDATE` | DATS | Follow-up appointment date |
| `SLOTSTATUS` | CHAR 20 | Confirmed / Pending / Done |

---

## 🔄 RAP Unmanaged — How It Works

```
User Action (Fiori UI)
        │
        ▼
   MODIFY call
        │
        ├──► lhc_AppointmentHdr::create()  ──► ZCL_APPT_UTIL_IT018::set_hdr_value()
        ├──► lhc_AppointmentHdr::update()  ──► (buffer in memory)
        ├──► lhc_AppointmentHdr::delete()  ──► set_hdr_deletion_flag()
        └──► lhc_AppointmentItem::*()      ──► set_itm_value() / set_itm_t_deletion()
                                                        │
                                                        ▼
                                              User clicks SAVE
                                                        │
                                                        ▼
                                         lsc_ZCIT_APPT_HI_IT018::save()
                                                        │
                                         ┌──────────────┼──────────────┐
                                         ▼              ▼              ▼
                                    MODIFY HDR    MODIFY ITM    DELETE FROM DB
                                  (Header Table) (Item Table)  (based on flags)
                                                        │
                                                        ▼
                                         lsc_*::cleanup() → clear buffer
```

---

## ⚙️ Prerequisites

- ✅ Eclipse ADT (ABAP Development Tools) installed
- ✅ Access to SAP BTP ABAP Environment or S/4HANA Cloud (RAP-enabled)
- ✅ Package `ZCIT_HOSP_IT018` created in your system
- ✅ Basic knowledge of CDS views and ABAP OOP

---

## 🚀 Setup Guide (Step-by-Step)

### Phase 1 — Database Tables
1. Create domain `ZSAPPT` (CHAR 10)
2. Create header table `ZCIT_APPT_H_IT018`
3. Create item table `ZCIT_APPT_I_IT018`

### Phase 2 — Interface Views
4. Create root interface view `ZCIT_APPT_HI_IT018` *(don't activate yet)*
5. Create child interface view `ZCIT_APPT_II_IT018` → **activate both together** (`Ctrl+Shift+F3`)

### Phase 3 — Consumption Views
6. Create header consumption view `ZCIT_APPT_HC_IT018` *(don't activate yet)*
7. Create item consumption view `ZCIT_APPT_IC_IT018` → **activate both together**

### Phase 4 — Metadata Extensions
8. Create header metadata extension `ZCIT_APPT_HC_IT018`
9. Create item metadata extension `ZCIT_APPT_IC_IT018`

### Phase 5 — Business Logic
10. Create utility class `ZCL_APPT_UTIL_IT018`
11. Create behavior definition `ZCIT_APPT_HI_IT018` (Unmanaged)
12. Create draft tables `ZCIT_APPT_HDR_D_IT018` & `ZCIT_APPT_ITM_D_IT018` via Quick Fix (`Ctrl+1`)
13. Generate implementation classes via Quick Fix
14. Implement header handler `ZBP_APPT_HDR_IT018` (Local Types tab)
15. Implement item handler `ZBP_APPT_ITM_IT018` (Local Types tab)
16. Implement saver class `ZBP_APPT_SAVER_IT018` (Local Types tab)

### Phase 6 — Service Exposure
17. Create projection behavior definition on `ZCIT_APPT_HC_IT018`
18. Create service definition `ZCIT_APPT_UI_IT018`
19. Create service binding `ZCIT_APPT_BIND_IT018` (OData V4 – UI) → **Publish**
20. Select `ZCIT_APPT_HC_IT018` in Entity Set list → click **Preview**

> 📖 For full code listings for every step, refer to the **[User Manual PDF/DOCX](./Hospital_Appointment_RAP_Unmanaged_IT018.docx)** in this repository.

---

## 🖥️ Demo Screens

### Creating an Appointment
```
1. Click "Create" on the list page
2. Enter Appointment ID → e.g., APPT001
3. Click Continue
```

### Filling Appointment Details
```
Patient Name    : John Doe
Age             : 35
Gender          : Male
Contact         : 9876543210
Doctor Name     : Dr. Priya Sharma
Department      : Cardiology
Appointment Date: 15.04.2026
Status          : Scheduled
Fee             : 500.00 INR
→ Click Save
```

### Adding a Slot
```
1. Open the appointment record
2. Go to "Slot Details" tab → Click Create
3. Slot Number  : 10
4. Slot Time    : 10:30:00
5. Diagnosis    : Hypertension
6. Prescription : Amlodipine 5mg
7. Follow-Up    : 15.05.2026
8. Slot Status  : Confirmed
→ Click Apply → Click Save
```

---

## 🧠 Key Concepts

| Concept | Explanation |
|---|---|
| **Unmanaged RAP** | You manually write all DB operations (MODIFY, DELETE) in handler and saver classes |
| **Singleton Buffer** | `ZCL_APPT_UTIL_IT018` holds data in memory between MODIFY and SAVE |
| **Draft Handling** | Users can save incomplete records as drafts; `Activate` commits them to the active DB table |
| **Composition** | Header owns Items — deleting a header cascades to all its slots |
| **Projection Views** | Consumption views project from interface views, enabling OData exposure without touching base CDS |
| **Metadata Extensions** | UI annotations (labels, facets, search fields) are added separately, keeping CDS views clean |

---

## 📋 Object Naming Convention

All objects follow the pattern: `Z` + `CIT` / `BL` + `_APPT_` + `<object>` + `_IT018`

| Prefix | Used for |
|---|---|
| `ZCIT_` | CDS Views, Tables, Service objects |
| `ZCL_` | Utility / Helper classes |
| `ZBP_` | Behavior implementation classes |
| `_IT018` | Student register number suffix |

---

## 📄 License

This project is submitted as an academic project under SAP ABAP Cloud curriculum guidance.  
**Student:** DEEPAK S | **Register No.:** 22IT018 | **Mentor:** Ajayan C

---

<div align="center">
  <sub>Built with ❤️ using SAP ABAP Cloud · RAP Unmanaged · OData V4 · SAP Fiori Elements</sub>
</div>
