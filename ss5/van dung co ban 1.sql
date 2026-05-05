-- SELECT restaurant_name, address, rating
-- FROM Restaurants
-- WHERE district = 'Quận 1' OR district = 'Quận 3' AND rating > 4.0;


-- Vì AND có tính ưu tiên hơn OR nên nó lấy hết district = 'Quận 1' còn district = 'Quận 3' thì lấy thêm rating > 4.0 nên ko dc tối ưu
-- Sửa lại thêm () vô 
SELECT restaurant_name, address, rating
FROM Restaurants
WHERE (district = 'Quận 1' OR district = 'Quận 3') AND rating > 4.0;

-- hoặc dùng IN 
SELECT restaurant_name, address, rating
FROM Restaurants
WHERE district IN ('Quận 1' ,'Quận 3') 
AND rating > 4.0;