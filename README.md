# RestMan — Servlet / JSP

Maven WAR, Java 17+, Jakarta Servlet 6, JSP/JSTL; chạy trên Tomcat 10.1+ hoặc Jetty 12.

## Cấu hình và chạy

1. Tạo CSDL bằng `createTable.sql` trên MySQL (script tạo bảng, không chạy lại trên CSDL đã có bảng).
2. Sao chép `.env.example` thành `.env` và đặt `DB_URL`, `DB_USER`, `DB_PASSWORD`. Không commit `.env`.
3. Trong thư mục `Code`, chạy `mvn jetty:run`, mở `http://localhost:8080/customer/HomeCustomerView9.jsp`.
4. Build WAR: `mvn package`; kết quả `target/servlet-jsp-demo.war`.
   Khi chạy WAR trên Tomcat, nên cấp cấu hình bằng biến môi trường cho tiến trình Tomcat.

## Đối chiếu luồng thiết kế

### Module 1 — Tìm món ăn / Combo

- `HomeCustomerView9.jsp` → `/customer/search-dish` → form `SearchDishView9.jsp`.
- Khi gửi `keyword`, `SearchDishServlet9` gọi `DishDAO9.search(keyword)`, rồi `ComboDAO9.search(keyword)`; đặt `listDish`, `listCombo` vào request và forward về trang tìm kiếm.
- Tìm tên chứa keyword. Keyword rỗng báo lỗi; mở form lần đầu và Reset không truy vấn.
- Chọn item gửi `action=detail&type=dish|combo&id=...&keyword=...`.
- Hai nhánh loại trừ: `getDishById(id)` hoặc `getComboById(id)`, đặt `dish` hoặc `combo`, cùng forward đến `ItemDetailView9.jsp`.
- Combo chi tiết chứa `listDish` gồm các `ComboDetail9` và `Dish9`; Back giữ keyword.
- URL cũ dùng `itemId`/`itemType` vẫn được hỗ trợ.

### Module 2 — Thống kê nhà cung cấp

- `ManagerHomeView9.jsp` → `StatisticMainView9.jsp` → `/stat-supplier` → form thống kê.
- `action=stat&start=...&end=...`: `SupplierStatisticDAO9.getStat(start,end)` → `listSupplierStat` → `SupplierStatisticView9.jsp`.
- `action=listImport&start=...&end=...&supplierId=...`: `ImportInvoiceDAO9.getListImport(...)` → `listInvoice` → `SupplierListImportView9.jsp`.
- `action=detail&invoiceId=...`: `ImportInvoiceDAO9.getById(...)` tạo phiếu nhập và danh sách chi tiết; chính DAO tạo từng `ImportDetail9`, có `Material9`, không giao việc truy vấn cho model.
- Khi đi từ danh sách, link chi tiết mang theo `start`, `end`, `supplierId`; Servlet kiểm tra phiếu thuộc bộ lọc. Back dùng URL cụ thể để giữ bộ lọc, Done về trang chủ quản lý.
- Khoảng ngày bao gồm cả ngày kết thúc. Thống kê sắp giảm dần theo lượng nhập; phiếu nhập sắp mới nhất trước.
- Truy vấn tổng tiền tách khỏi truy vấn tổng số lượng để không nhân tổng tiền theo số dòng chi tiết.
- Theo mô hình hiện tại, lượng nhập là tổng số lượng ghi trên các dòng; không phải quy đổi kg/lít/cái sang cùng đơn vị.

## Những khác biệt có chủ đích với UML

- Dùng `List<T>` thay mảng `T[]` cho các danh sách.
- `DAO` dùng `getConnection()` và try-with-resources, không giữ một Connection dùng chung.
- Các bước “gọi DAO / gọi phương thức” trên sequence tương ứng cùng một lời gọi Java; không tạo self-call thừa chỉ để khớp số bước.
- DAO tạo và điền model từ ResultSet. Các model giữ dữ liệu và quan hệ, không tự truy vấn CSDL.
- Sơ đồ lớp cần có dependency `ImportInvoiceDAO9 ..> ImportDetail9 : <<create>>`, và dependency tới `Material9`, `Supplier9`, `WarehouseStaff9`, `Address9`, `Fullname9` khi thể hiện đầy đủ các kiểu được DAO sử dụng.

## Giới hạn hiện tại

Đăng nhập quản lý dùng tài khoản `tblMember9` có `role = Manager`, `status = active` và mật khẩu PBKDF2. Mật khẩu thuần từ bản demo cũ không được chấp nhận.

Dữ liệu mẫu trong `createTable.sql` hiện chỉ có món ăn và combo; muốn chạy hết luồng thống kê cần có nhà cung cấp, nhân viên kho, nguyên liệu, phiếu nhập và chi tiết tương ứng.

## Giao diện

Hai module dùng chung `src/main/webapp/assets/restman.css`: nền trắng, banner xanh nhạt, nút xanh dương, bảng cuộn ngang trên màn nhỏ và số tiền theo locale Việt Nam.

Trang mặc định `/` và `/home` mở trang chủ khách hàng. `HomeServlet` chỉ map `/home` để container phục vụ CSS/ảnh tĩnh qua default servlet.

Các màn: trang chủ khách hàng, tìm kiếm, chi tiết món/combo, trang chủ quản lý, chọn báo cáo, thống kê nhà cung cấp, danh sách phiếu nhập, chi tiết phiếu nhập. Ba loại thống kê ngoài module nhà cung cấp được hiển thị là chưa triển khai.

## Đăng nhập quản lý

1. Build: `mvn package`.
2. Tạo tài khoản trong terminal tương tác (tự chọn username, mật khẩu được nhập ẩn):

   ```bash
   java -cp 'target/classes:target/servlet-jsp-demo/WEB-INF/lib/*' com.example.util.CreateManager9 admin
   ```

   Công cụ dùng cấu hình DB hiện có trong `.env`, chỉ tạo tài khoản mới và không đổi tài khoản trùng tên. Địa chỉ ban đầu để trống.
3. Mở `/login` hoặc nhấn Đăng nhập quản lý ở trang chủ khách hàng.
4. Đăng nhập đúng sẽ về trang chủ quản lý. Các URL `/manager/*` và `/stat-supplier` yêu cầu session đăng nhập. Đăng xuất bằng nút trong thanh điều hướng.

Mật khẩu lưu dạng `pbkdf2_sha256$iterations$salt$hash`, 600.000 vòng, salt ngẫu nhiên 16 byte, so sánh hash bằng `MessageDigest.isEqual`. Không lưu mật khẩu/hash trong session. Session mới sau đăng nhập và hết hạn sau 30 phút không hoạt động. Không có tài khoản/mật khẩu mặc định.

`createTable.sql` đã đặt UNIQUE cho userName khi tạo CSDL mới. Với CSDL cũ, kiểm tra username trùng trước khi thêm ràng buộc UNIQUE; DAO từ chối đăng nhập khi có nhiều tài khoản cùng tên. Tài khoản cũ lưu plaintext cần được cập nhật hash riêng, không tự động ghi đè.
