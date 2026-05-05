# 📘 BÀI TẬP MYSQL - MINDMAP

## 📌 Mô tả

Bài tập này thực hiện việc thiết kế và xây dựng cơ sở dữ liệu bằng MySQL, bao gồm từ bước phân tích yêu cầu đến triển khai bảng và truy vấn dữ liệu.

---

## 🧠 Mindmap

Có Mindmap cho các bài 

---

## 🗂️ Cấu trúc cơ sở dữ liệu

### Các bảng chính:

* **Product**: Lưu thông tin sản phẩm
* **Customer**: Lưu thông tin khách hàng
* **Orders**: Lưu thông tin đơn hàng
* **OrderDetail**: Chi tiết từng đơn hàng

---

## 🔑 Quan hệ giữa các bảng

* Một khách hàng (**Customer**) có thể có nhiều đơn hàng (**Orders**)
* Một đơn hàng (**Orders**) có nhiều chi tiết (**OrderDetail**)
* Một sản phẩm (**Product**) có thể xuất hiện trong nhiều chi tiết đơn hàng

---

## ⚙️ Nội dung đã thực hiện

* Thiết kế mô hình dữ liệu (ERD)
* Tạo bảng bằng lệnh `CREATE TABLE`
* Thiết lập khóa chính (PRIMARY KEY)
* Thiết lập khóa ngoại (FOREIGN KEY)
* Thêm, sửa, xóa dữ liệu (INSERT, UPDATE, DELETE)
* Truy vấn dữ liệu (SELECT, JOIN)

---

## 🧪 Ví dụ truy vấn

```sql
SELECT p.ProductName, od.Quantity
FROM Product p
JOIN OrderDetail od ON p.ProductID = od.ProductID;
```

---

## 🚀 Hướng dẫn sử dụng

1. Mở MySQL Workbench hoặc phpMyAdmin
2. Tạo database mới
3. Chạy file `.sql` để tạo bảng
4. Thực hiện các truy vấn để kiểm tra dữ liệu

---

## 📌 Ghi chú

* Bài làm mang tính chất học tập
* Chưa tối ưu hiệu năng nâng cao
* Có thể mở rộng thêm chức năng trong tương lai

---
