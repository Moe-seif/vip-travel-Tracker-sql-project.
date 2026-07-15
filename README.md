# vip-travel-Tracker-sql-project.
The project builds a structured tracking engine that monitors hotel confirmation numbers (HCN), Payment Pending, and team reminder dispatch statuses to ensure zero-error execution for high-priority bookings.
# VIP Travel Operations & Financial Audit Engine

##  Project Overview
In high-volume travel operations, missing a payment deadline or failing to send a final confirmation reminder can lead to critical booking cancellations. I developed this relational database tracking model to eliminate these operational gaps at a VIP travel desk. 

The project has evolved from a single manifest log into a multi-table relational model that connects travel management milestones directly to vendor cash-flow risk evaluations and profit margin audits.

## 🛠️ SQL Concepts Applied
* **Schema Design & Relational Integrity (DDL):** `CREATE TABLE` structures utilizing `PRIMARY KEY` indexing, foreign key alignment, `NOT NULL` data enforcement, and deterministic `DEFAULT` state flags.
* **Data Mocking (DML):** `INSERT INTO` statements generating a multi-state testing dataset across normalized tables reflecting realistic operational and financial scenarios.
* **Data Analytics & Advanced Logic:** Multi-conditional logic (`AND`), temporal filtering (`BETWEEN`), table joins (`INNER JOIN`, `LEFT JOIN`), advanced conditional grouping (`SUM(CASE WHEN...)`), and date arithmetic (`DATEADD`, `GETDATE`).

##  Database Schema Architecture
The data layer utilizes a normalized structure connected via a **Primary Key ➔ Foreign Key** relationship:

1. **`vip_bookings` (Operations):**
   * `BookingId`: Primary key enforcing data uniqueness.
   * `PassengerName`: Name of the VIP guest.
   * `Traveldate`: Scheduled date of arrival/departure.
   * `HCN`: Hotel Confirmation Number (allows `NULL` values as suppliers often share this reference 1 to 2 days post-booking).
   * `consultant`: The account manager handling the booking file.
   * `Paid` / `reminder_sent`: System workflow flags (`Yes`/`No`) driving core tracking logic.

2. **`booking_finance` (Financial Ledger - New):**
   * `BookingId`: Primary key linking directly back to the operational manifest.
   * `SupplierName`: The individual vendor or hotel group handling the reservation.
   * `CostPrice`: Wholesale rate owed to the supplier.
   * `SellingPrice`: Retail rate charged to the client.

##  Core Operational & Financial Queries Solved
The unified script runs advanced business intelligence queries divided into two distinct operational layers:

### 1. Operations Tracking
* **Urgent Action Queue:** Instantly isolates high-risk bookings where payment is outstanding AND no notification reminder has been sent yet, preventing supplier cancellations.
* **Workload Distribution Filter:** Extracts active files assigned to a specific consultant, making it easy for supervisors to audit individual workloads or redistribute files across the team.
* **Temporal Travel Audit:** Filters and identifies bookings falling within specific fiscal date ranges to monitor upcoming volume spikes.
* **Consultant Productivity Matrix:** Aggregates and ranks the team based on total active bookings managed to evaluate desk capacity.

### 2. Supplier & Revenue Finance Analytics (New)
* **Dynamic Profit Margin Tracking:** Computes true profit margins and net margin percentages on the fly using relational calculations.
* **Supplier Performance Ranking:** Aggregates gross revenue and net profit sorted by vendor to identify the most valuable supplier relationships.
* **Supplier Debt Risk Audit:** Isolates precise outstanding cash volumes owed to each hotel vendor for unpaid bookings to protect reservation inventory.
* **7-Day Payment Deadline Alert:** Leverages live date math to filter for high-risk files where a traveler arrives within 7 days but the supplier balance is still unpaid.
* **Supplier Priority Tiering Matrix:** Combines `SUM` with conditional `CASE WHEN` logic to automatically segment vendors into risk groups ('Critical Balance', 'Pending Balance', 'Settled') based on active financial exposure.
