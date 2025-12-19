-- =====================================================
-- 1. KPIs GLOBAUX
-- =====================================================

-- Chiffre d'affaires total
SELECT 
    SUM(Sales) AS total_sales
FROM orders;

-- Profit total
SELECT 
    SUM(Profit) AS total_profit
FROM orders;

-- Nombre total de commandes
SELECT 
    COUNT(DISTINCT Order_ID) AS total_orders
FROM orders;

-- Nombre total de clients
SELECT 
    COUNT(DISTINCT Customer_ID) AS total_customers
FROM orders;

-- Marge bénéficiaire globale (%)
SELECT 
    ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS profit_margin_pct
FROM orders;

-- =====================================================
-- 2. ANALYSE TEMPORELLE
-- =====================================================

-- Ventes par année
SELECT 
    YEAR(Order_Date) AS year,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM orders
GROUP BY year
ORDER BY year;

-- Ventes par mois (année + mois)
SELECT 
    DATE_FORMAT(Order_Date, '%Y-%m') AS year_month,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM orders
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY DATE_FORMAT(Order_Date, '%Y-%m');

-- =====================================================
-- 3. ANALYSE PAR CATÉGORIE
-- =====================================================

-- Ventes, profit et marge par catégorie
SELECT 
    Category,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS profit_margin_pct
FROM orders
GROUP BY Category
ORDER BY total_profit DESC;

-- =====================================================
-- 4. TOP PRODUITS
-- =====================================================

-- Top 10 produits par chiffre d'affaires
SELECT 
    Product_Name,
    SUM(Sales) AS total_sales
FROM orders
GROUP BY Product_Name
ORDER BY total_sales DESC
LIMIT 10;

-- =====================================================
-- 5. PRODUITS NON RENTABLES
-- =====================================================

SELECT 
    Product_Name,
    SUM(Profit) AS total_profit
FROM orders
GROUP BY Product_Name
HAVING total_profit < 0
ORDER BY total_profit;

-- =====================================================
-- 6. ANALYSE CLIENTS
-- =====================================================

-- Top 10 clients par ventes
SELECT 
    Customer_Name,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM orders
GROUP BY Customer_Name
ORDER BY total_sales DESC
LIMIT 10;

-- Clients non rentables
SELECT 
    Customer_Name,
    SUM(Profit) AS total_profit
FROM orders
GROUP BY Customer_Name
HAVING total_profit < 0
ORDER BY total_profit;

-- =====================================================
-- 7. ANALYSE GÉOGRAPHIQUE
-- =====================================================

-- Ventes et profit par région
SELECT 
    Region,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS profit_margin_pct
FROM orders
GROUP BY Region
ORDER BY total_profit DESC;

-- =====================================================
-- 8. IMPACT DES REMISES
-- =====================================================

SELECT 
    Discount,
    COUNT(*) AS total_orders,
    ROUND(AVG(Sales), 2) AS avg_sales,
    ROUND(AVG(Profit), 2) AS avg_profit
FROM orders
GROUP BY Discount
ORDER BY Discount;

-- =====================================================
-- 9. CASE WHEN (PROFITABILITÉ)
-- =====================================================

SELECT 
    Category,
    SUM(Profit) AS total_profit,
    CASE
        WHEN SUM(Profit) > 0 THEN 'Profitable'
        ELSE 'Not Profitable'
    END AS profitability_status
FROM orders
GROUP BY Category;

-- =====================================================
-- 10. WINDOW FUNCTIONS (FONCTIONS FENÊTRES)
-- =====================================================

-- Top 10 produits par ventes avec ranking
SELECT *
FROM (
    SELECT 
        Product_Name,
        SUM(Sales) AS total_sales,
        RANK() OVER (ORDER BY SUM(Sales) DESC) AS sales_rank
    FROM orders
    GROUP BY Product_Name
) AS ranked_products
WHERE sales_rank <= 10
ORDER BY sales_rank;
