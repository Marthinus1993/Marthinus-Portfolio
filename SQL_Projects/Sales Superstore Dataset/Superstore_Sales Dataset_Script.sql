-- The purpose of this exercise is to determine the Sales, Profit, Sales Target for 2011, 2012, 2013 and 2014
-- The exercise will indicate which category and segments are performing and underperforming. 
-- Create a new Superstore Sales Dataset with necessary columns and update columns to correct data format
CREATE TABLE New_Superstore_dataset_Table AS
SELECT 
    *,
    CAST(REPLACE(Sales, 'US$', '') AS NUMERIC) AS Sales_Amount,  -- Add Sales_Amount column
    CAST(REPLACE(REPLACE(Profit, '(US$', '-'), 'US$', '') AS NUMERIC) AS Profit_Amount,  -- Add Profit_Amount column
    CASE 
        WHEN substr("Order Date", -2, 2) < '30' 
        THEN '20' || substr("Order Date", -2, 2) || '-' ||
             CASE 
                 WHEN length(substr("Order Date", instr("Order Date", '/') + 1, instr(substr("Order Date", instr("Order Date", '/') + 1), '/') - 1)) = 1 
                 THEN '0' || substr("Order Date", instr("Order Date", '/') + 1, instr(substr("Order Date", instr("Order Date", '/') + 1), '/') - 1) 
                 ELSE substr("Order Date", instr("Order Date", '/') + 1, instr(substr("Order Date", instr("Order Date", '/') + 1), '/') - 1)
             END || '-' ||
             CASE 
                 WHEN length(substr("Order Date", 1, instr("Order Date", '/') - 1)) = 1 
                 THEN '0' || substr("Order Date", 1, instr("Order Date", '/') - 1) 
                 ELSE substr("Order Date", 1, instr("Order Date", '/') - 1)
             END
        ELSE '19' || substr("Order Date", -2, 2) || '-' ||
             CASE 
                 WHEN length(substr("Order Date", instr("Order Date", '/') + 1, instr(substr("Order Date", instr("Order Date", '/') + 1), '/') - 1)) = 1 
                 THEN '0' || substr("Order Date", instr("Order Date", '/') + 1, instr(substr("Order Date", instr("Order Date", '/') + 1), '/') - 1) 
                 ELSE substr("Order Date", instr("Order Date", '/') + 1, instr(substr("Order Date", instr("Order Date", '/') + 1), '/') - 1)
             END || '-' ||
             CASE 
                 WHEN length(substr("Order Date", 1, instr("Order Date", '/') - 1)) = 1 
                 THEN '0' || substr("Order Date", 1, instr("Order Date", '/') - 1) 
                 ELSE substr("Order Date", 1, instr("Order Date", '/') - 1)
             END
    END AS Formatted_Order_Date
FROM Superstore_dataset_Table
;

-- Verify added columns
PRAGMA table_info(New_Superstore_dataset_Table)
;

-- Confirm changes to columns
SELECT 
    *
FROM New_Superstore_dataset_Table
LIMIT 10
;

-- Drop the old table if it's no longer needed
DROP TABLE Superstore_dataset_Table
;

-- Create a Sales Target Table with updated columns and correct data format
CREATE TABLE New_Sales_Target_Table AS
SELECT 
    *,
    CASE 
        WHEN substr("Order Date", -2, 2) < '30' 
        THEN '20' || substr("Order Date", -2, 2) || '-' ||
             CASE 
                 WHEN length(substr("Order Date", instr("Order Date", '/') + 1, instr(substr("Order Date", instr("Order Date", '/') + 1), '/') - 1)) = 1 
                 THEN '0' || substr("Order Date", instr("Order Date", '/') + 1, instr(substr("Order Date", instr("Order Date", '/') + 1), '/') - 1) 
                 ELSE substr("Order Date", instr("Order Date", '/') + 1, instr(substr("Order Date", instr("Order Date", '/') + 1), '/') - 1)
             END || '-' ||
             CASE 
                 WHEN length(substr("Order Date", 1, instr("Order Date", '/') - 1)) = 1 
                 THEN '0' || substr("Order Date", 1, instr("Order Date", '/') - 1) 
                 ELSE substr("Order Date", 1, instr("Order Date", '/') - 1)
             END
        ELSE '19' || substr("Order Date", -2, 2) || '-' ||
             CASE 
                 WHEN length(substr("Order Date", instr("Order Date", '/') + 1, instr(substr("Order Date", instr("Order Date", '/') + 1), '/') - 1)) = 1 
                 THEN '0' || substr("Order Date", instr("Order Date", '/') + 1, instr(substr("Order Date", instr("Order Date", '/') + 1), '/') - 1) 
                 ELSE substr("Order Date", instr("Order Date", '/') + 1, instr(substr("Order Date", instr("Order Date", '/') + 1), '/') - 1)
             END || '-' ||
             CASE 
                 WHEN length(substr("Order Date", 1, instr("Order Date", '/') - 1)) = 1 
                 THEN '0' || substr("Order Date", 1, instr("Order Date", '/') - 1) 
                 ELSE substr("Order Date", 1, instr("Order Date", '/') - 1)
             END
    END AS Updated_Order_Date
FROM Sales_Target_Table
;

-- Verify added columns
PRAGMA table_info(New_Sales_Target_Table)
;

-- Confirm changes to columns
SELECT 
    *
FROM New_Sales_Target_Table nstt 
LIMIT 10
;

-- Drop the old table if it's no longer needed
DROP TABLE Sales_Target_Table 
;

-- Calculate Total Sales by Segment and Category for each year
SELECT 
    nsdt.Category,
    nsdt.Segment,
    SUM(CASE WHEN strftime('%Y', nsdt.formatted_order_date) = '2011' THEN nsdt.Sales_Amount * nsdt.Quantity ELSE 0 END) AS 'Total Sales 2011',
    SUM(CASE WHEN strftime('%Y', nsdt.formatted_order_date) = '2012' THEN nsdt.Sales_Amount * nsdt.Quantity ELSE 0 END) AS 'Total Sales 2012',
    SUM(CASE WHEN strftime('%Y', nsdt.formatted_order_date) = '2013' THEN nsdt.Sales_Amount * nsdt.Quantity ELSE 0 END) AS 'Total Sales 2013',
    SUM(CASE WHEN strftime('%Y', nsdt.formatted_order_date) = '2014' THEN nsdt.Sales_Amount * nsdt.Quantity ELSE 0 END) AS 'Total Sales 2014'
FROM New_Superstore_dataset_Table nsdt
GROUP BY 
    nsdt.Segment,
    nsdt.Category
ORDER BY 
    nsdt.Segment, nsdt.Category
;

-- Calculate Total Profit by Segment and Cateogry for each year
SELECT 
    nsdt.Category,
    nsdt.Segment,
    SUM(CASE WHEN strftime('%Y', nsdt.formatted_order_date) = '2011' THEN nsdt.Profit_Amount * nsdt.Quantity ELSE 0 END) AS 'Total Profit 2011',
    SUM(CASE WHEN strftime('%Y', nsdt.formatted_order_date) = '2012' THEN nsdt.Profit_Amount * nsdt.Quantity ELSE 0 END) AS 'Total Profit 2012',
    SUM(CASE WHEN strftime('%Y', nsdt.formatted_order_date) = '2013' THEN nsdt.Profit_Amount * nsdt.Quantity ELSE 0 END) AS 'Total Profit 2013',
    SUM(CASE WHEN strftime('%Y', nsdt.formatted_order_date) = '2014' THEN nsdt.Profit_Amount * nsdt.Quantity ELSE 0 END) AS 'Total Profit 2014'
FROM New_Superstore_dataset_Table nsdt
GROUP BY 
    nsdt.Segment,
    nsdt.Category
ORDER BY 
    nsdt.Segment, nsdt.Category
;

-- Calculate Total Sales Target by Segment and Category for each year
SELECT 
	nstt.Category,
	nstt.Segment,
    SUM(CASE WHEN strftime('%Y', nstt.Updated_Order_Date) = '2011' THEN nstt."Sales Target" ELSE 0 END) AS 'Total Sales Target 2011',
    SUM(CASE WHEN strftime('%Y', nstt.Updated_Order_Date) = '2012' THEN nstt."Sales Target" ELSE 0 END) AS 'Total Sales Target 2012',
    SUM(CASE WHEN strftime('%Y', nstt.Updated_Order_Date) = '2013' THEN nstt."Sales Target" ELSE 0 END) AS 'Total Sales Target 2013',
    SUM(CASE WHEN strftime('%Y', nstt.Updated_Order_Date) = '2014' THEN nstt."Sales Target" ELSE 0 END) AS 'Total Sales Target 2014'	
    FROM New_Sales_Target_Table nstt 
GROUP BY 
	nstt.Segment,
	nstt.Category
ORDER BY 
	nstt.Segment, nstt.Category
;

-- Combine Total Sales, Total Sales Target and Total Profit as a single Table
SELECT 
    sales.Category,
    sales.Segment,

    -- Year 2011
    sales."Total Sales 2011",
    target."Total Sales Target 2011",
    profit."Total Profit 2011",
    
    
    -- Year 2012
    sales."Total Sales 2012",
    target."Total Sales Target 2012",
    profit."Total Profit 2012",
    
    -- Year 2013
    sales."Total Sales 2013",
    target."Total Sales Target 2013",
    profit."Total Profit 2013",

    -- Year 2014
    sales."Total Sales 2014",
    target."Total Sales Target 2014",
    profit."Total Profit 2014" 

FROM 
    (SELECT 
        nsdt.Category,
        nsdt.Segment,
        SUM(CASE WHEN strftime('%Y', nsdt.formatted_order_date) = '2011' THEN nsdt.Sales_Amount * nsdt.Quantity ELSE 0 END) AS "Total Sales 2011",
        SUM(CASE WHEN strftime('%Y', nsdt.formatted_order_date) = '2012' THEN nsdt.Sales_Amount * nsdt.Quantity ELSE 0 END) AS "Total Sales 2012",
        SUM(CASE WHEN strftime('%Y', nsdt.formatted_order_date) = '2013' THEN nsdt.Sales_Amount * nsdt.Quantity ELSE 0 END) AS "Total Sales 2013",
        SUM(CASE WHEN strftime('%Y', nsdt.formatted_order_date) = '2014' THEN nsdt.Sales_Amount * nsdt.Quantity ELSE 0 END) AS "Total Sales 2014"
    FROM New_Superstore_dataset_Table nsdt
    GROUP BY nsdt.Segment, nsdt.Category
    ) AS sales

LEFT JOIN 
    (SELECT 
        nsdt.Category,
        nsdt.Segment,
        SUM(CASE WHEN strftime('%Y', nsdt.formatted_order_date) = '2011' THEN nsdt.Profit_Amount * nsdt.Quantity ELSE 0 END) AS "Total Profit 2011",
        SUM(CASE WHEN strftime('%Y', nsdt.formatted_order_date) = '2012' THEN nsdt.Profit_Amount * nsdt.Quantity ELSE 0 END) AS "Total Profit 2012",
        SUM(CASE WHEN strftime('%Y', nsdt.formatted_order_date) = '2013' THEN nsdt.Profit_Amount * nsdt.Quantity ELSE 0 END) AS "Total Profit 2013",
        SUM(CASE WHEN strftime('%Y', nsdt.formatted_order_date) = '2014' THEN nsdt.Profit_Amount * nsdt.Quantity ELSE 0 END) AS "Total Profit 2014"
    FROM New_Superstore_dataset_Table nsdt
    GROUP BY nsdt.Segment, nsdt.Category
    ) AS profit
ON sales.Category = profit.Category AND sales.Segment = profit.Segment

LEFT JOIN 
    (SELECT 
        nstt.Category,
        nstt.Segment,
        SUM(CASE WHEN strftime('%Y', nstt.Updated_Order_Date) = '2011' THEN nstt."Sales Target" ELSE 0 END) AS "Total Sales Target 2011",
        SUM(CASE WHEN strftime('%Y', nstt.Updated_Order_Date) = '2012' THEN nstt."Sales Target" ELSE 0 END) AS "Total Sales Target 2012",
        SUM(CASE WHEN strftime('%Y', nstt.Updated_Order_Date) = '2013' THEN nstt."Sales Target" ELSE 0 END) AS "Total Sales Target 2013",
        SUM(CASE WHEN strftime('%Y', nstt.Updated_Order_Date) = '2014' THEN nstt."Sales Target" ELSE 0 END) AS "Total Sales Target 2014"
    FROM New_Sales_Target_Table nstt 
    GROUP BY nstt.Segment, nstt.Category
    ) AS target
ON sales.Category = target.Category AND sales.Segment = target.Segment

ORDER BY sales.Segment, sales.Category
;

-- Identify the regions performance by Sales and Profit
SELECT 
	nsdt.Region,
	SUM(CASE WHEN strftime('%Y', nsdt.Formatted_Order_Date) = '2011' THEN nsdt."Sales_Amount" * nsdt.Quantity ELSE 0 END) AS "Total Sales 2011",
	SUM(CASE WHEN strftime('%Y', nsdt.Formatted_Order_Date) = '2011' THEN nsdt.Profit_Amount * nsdt.Quantity ELSE 0 END) AS "Total Profit 2011",
	SUM(CASE WHEN strftime('%Y', nsdt.Formatted_Order_Date) = '2012' THEN nsdt."Sales_Amount" * nsdt.Quantity ELSE 0 END) AS "Total Sales 2012",
	SUM(CASE WHEN strftime('%Y', nsdt.Formatted_Order_Date) = '2012' THEN nsdt.Profit_Amount * nsdt.Quantity ELSE 0 END) AS "Total Profit 2012",
	SUM(CASE WHEN strftime('%Y', nsdt.Formatted_Order_Date) = '2013' THEN nsdt."Sales_Amount" * nsdt.Quantity ELSE 0 END) AS "Total Sales 2013",
	SUM(CASE WHEN strftime('%Y', nsdt.Formatted_Order_Date) = '2013' THEN nsdt.Profit_Amount * nsdt.Quantity ELSE 0 END) AS "Total Profit 2013",
	SUM(CASE WHEN strftime('%Y', nsdt.Formatted_Order_Date) = '2014' THEN nsdt."Sales_Amount" * nsdt.Quantity ELSE 0 END) AS "Total Sales 2014",
	SUM(CASE WHEN strftime('%Y', nsdt.Formatted_Order_Date) = '2014' THEN nsdt.Profit_Amount * nsdt.Quantity ELSE 0 END) AS "Total Profit 2014"
FROM New_Superstore_dataset_Table nsdt
GROUP BY nsdt.Region
; 









