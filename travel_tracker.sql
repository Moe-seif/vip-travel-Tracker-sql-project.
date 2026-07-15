-- =========================================================
-- PORTFOLIO PROJECT #1: VIP TRAVEL DATABASE
-- AUTHOR: Mohamed Hossam
-- DESCRIPTION: A relational database structure to manage 
--              high-priority (VIP) flight data and automate 
--              operational tracking Via inserting Data of real travel to track them early on
--              to avoid Errors.
-- =========================================================
-- Table Creation: 
Create Table vip_bookings(
    BookingId INT Primary key,
    PassengerName Varchar(100) not null,
    Traveldate Date not null,
    HCN Varchar(50) Null,
    consultant Varchar(20) not null,
    Paid varchar(3) default 'No' not null,
    reminder_sent varchar(3) default 'No' not null
);   
-- 2. INSERT TEST DATA (PORTFOLIO DATASET)
Insert into Vip_bookings (BookingId,PassengerName,Traveldate,HCN,consultant,Paid,reminder_sent) values
(1,'Ahmed Mohamed','2019-12-15','HCN12345','Ahmed','Yes','Yes'),
(2,'Sara Ali','2020-01-10','HCN67890','Mohamed','No','No'),
(3,'Omar Hassan','2020-02-20',Null,'Sara','Yes','No'),
(4,'Laila Youssef','2020-03-05','HCN54321','Sayed','No','Yes'),
(5,'Youssef Karim','2020-04-18',Null,'Sara','Yes','Yes');
========================================================
--3.BI & Operations Queries

--3.1 Query to retrieve all bookings that have not been paid yet and not reminded yet
Select * from Vip_bookings
 where Paid ='No' and reminder_sent='No';

--3.2 Query to retrieve all bookings for a specific consultant (e.g., 'Ahmed')
Select * from Vip_bookings
 Where consultant='Ahmed';

--3.3 Query to retrieve all bookings for a specific travel date range 
--(e.g., between '2020-01-01' and '2020-03-31')
Select * from Vip_bookings
Where Traveldate Between '2020-01-01' and '2020-03-31';

-- 3.4 Performance Audit (Count total bookings managed by each consultant)
Select consultant, count(*) as Totalbookings
From Vip_bookings
Group by consultant
Order by Totalbookings desc;
-- =========================================================
-- PHASE 4: ADVANCED REVENUE, SUPPLIER PERFORMANCE & RISK
-- =========================================================
-- =========================================================
-- PORTFOLIO PROJECT #2: SUPPLIER & REVENUE AUDIT SYSTEM
-- AUTHOR: Mohamed Hossam
-- DESCRIPTION: Expanding the VIP travel database into a 
--              relational structure to track supplier costs,
--              profit margins, and revenue leakage.
-- =========================================================
-- Create Table the FINANCIAL data 
Create Table booking_finance(
    BookingID INT Not null primary key,
    SupplierName Varchar(50) Not null,
    CostPrice decimal(10,2) not null,
    SellingPrice Decimal(10,2) not null
)

=========================================================
-- Inserting sample data into the booking_finance table
Insert into booking_finance (BookingID, SupplierName, CostPrice, SellingPrice)
Values 
(1,'Trav', 500.00, 750.00),
(2,'FlyHigh', 300.00, 450.00),
(3,'SkyTours', 400.00, 600.00),
(4,'JetSet', 350.00, 525.00),
(5,'Trav', 450.00, 675.00);

-- =========================================================
-- Advanced Revenue & Supplier Analytics
-- =========================================================
-- Query 4.1: Profit Margin Analysis per Booking
-- Shows math calculations directly inside SQL using aliases
Select 
    V.bookingID,
    f.SupplierName,
    f.CostPrice,
    f.SellingPrice,
    f.SellingPrice - f.CostPrice AS [Profit Margin],
    ROUND(((f.SellingPrice - f.CostPrice) * 100.0 / f.SellingPrice), 2) AS [Profit Margin Percent] 
from vip_bookings V 
Inner Join booking_finance f
ON f.BookingId = V.BookingID;

-- Query 4.2: Supplier Revenue Breakdown & Profitability Ranking
-- To Show the total bookings handled by each supplier, total gross revenue, 
-- and total net profit per supplier, ordered by profitability
Select 
	f.SupplierName,
	Count(f.BookingID) As [Total Bookings handled],
	Sum(f.sellingPrice) as [total Gross],
	Sum(f.sellingPrice - f.Costprice) As [total net Profit]
	From vip_bookings v
	Left Join booking_finance f ON v.BookingID = f.BookingID
	Group by f.SupplierName
	Order by Sum(f.sellingPrice - f.Costprice) desc

-- Query 4.3: Supplier Debt Risk Audit
-- Finds how much money we owe to each supplier for unpaid bookings
	Select 	
		f.SupplierName,
		Count(f.SupplierName) AS [Unpaid Booking Counrt],
		Sum(costPrice) AS [Total owed to Supplier]
	From vip_bookings v
	Left Join booking_finance f ON v.BookingID = f.BookingID
	Where Paid ='No'
	Group by f.SupplierName

    -- Query 5: 7-Day Supplier Payment Deadline Alert
    -- Identifies bookings that are due for payment within the next 7 days
    -- to alert the finance team
    Select 
        v.BookingId,
        v.PassengerName,
        v.Traveldate,
        f.SupplierName,
        f.costPrice
    From vip_bookings v 
    Left Join booking_finance f ON v.BookingID = f.BookingID
    Where Paid = 'No' And 
    v.Traveldate <= DATEADD(Day, 7, Getdate());

-- Query 6: Supplier Priority Tiering Matrix
-- Classifies suppliers into tiers to check what has priority to pay.
Select 
f.SupplierName,
Sum(Case When v.Paid = 'No' Then f.CostPrice Else 0 END) AS TotalOwed,
Case 
	When sum(Case When v.Paid = 'No' Then f.CostPrice Else 0 END) > 500 
	Then 'Critical Balance'
	
	When sum(Case When v.Paid = 'No' Then f.CostPrice Else 0 END) Between 1 and 500 
	Then 'Pending Balance'

	ElSE 'Settled'
	END AS [Priority Tiering]
From vip_bookings v
Left Join booking_finance f  ON v.BookingID = f.BookingID
Group by f.SupplierName;




