-- SELECT city, SUM(total_price) AS revenue
-- FROM Bookings
-- WHERE status = 'COMPLETED' AND SUM(total_price) > 0
-- GROUP BY city;

-- Vì WHERE chạy trước SUM nên nó ko hiểu cú pháp 
-- để sửa cái này thì dùng HAVING 

-- Sửa lại 

SELECT city, SUM(total_price) AS revenue
FROM Bookings
WHERE status = 'COMPLETED'
GROUP BY city
HAVING SUM(total_price) > 0;
