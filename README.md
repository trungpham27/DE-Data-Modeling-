# DE-Data Modeling With Data Vault & Dimensional Model

## 1. Relational Model gốc
![MODELS-Relational Model drawio](https://github.com/trungpham27/DE-Data-Modeling-/assets/160450740/9b6ab608-e3cc-4ebd-a905-fb9964ec9a02)

## 2. Xây dựng mô hình dữ liệu cho Data Warehouse bằng Data Vault
### 2.1. Mô hình hoá các HUB
- Chúng ta đã có sẵn các khái niệm kinh doanh cốt lõi từ Relational Model gốc, vậy nên các HUB sẽ được xây dựng dựa trên các thực thể này.
- Tổng cộng có 9 HUB từ 9 thực thể ban đầu, không tính 2 thực thể liên kết.
![MODELS-HUBS drawio](https://github.com/trungpham27/DE-Data-Modeling-/assets/160450740/cd246b59-5c22-4c70-a00b-b1eae4ef4cf8)

### 2.2. Mô hình hoá các LINK
- Các LINK được xây dựng dựa trên mối quan hệ giữa các HUB với nhau.
- Như trong hình, có tổng cộng 8 LINK cơ bản:
	+ L_PROD_CAT: Liên kết giữa H_PRODUCTS và H_CATEGORIES
	+ L_PROD_SPLR: Liên kết giữa H_PRODUCTS và H_SUPPLIERS
	+ L_ORD_PROD: Liên kết giữa H_ORDERS và H_PRODUCTS
	+ L_ORD_SHPR: Liên kết giữa H_ORDERS và H_SHIPPERS
	+ L_ORD_CUST: Liên kết giữa H_ORDERS và H_CUSTOMERS
	+ L_ORD_EE: Liên kết giữa H_ORDERS và H_EMPLOYEES
	+ L_RGN_TERR: Liên kết giữa H_REGION và H_TERRITORIES
	+ L_EE_TERR: Liên kết giữa H_EMPLOYEES và H_TERRITORIES

- Cùng với đó là 2 LINK đặc biệt:
	+ SAL_CUSTOMERS: Same-as LINK này được xây dựng với mục đích nối các CustomerID từ những hệ thống nguồn khác nhau. Ví dụ: một khách hàng có thể có một mã số khách hàng riêng biệt trong hệ thống CRM nhưng lại có một mã số khác trong hệ thống Sales, lúc đó, H_CUSTOMERS sẽ lưu cả 2 mã số này trong 2 dòng khác nhau và LINK này sẽ giúp chúng ta nhận diện rằng 2 mã số đó chỉ là 1 khách hàng.
	+ HL_EE_MGR: Hierarchical LINK thể hiện mối quan hệ cấp bậc đối với nhân viên. Một nhân viên có thể là quản lý của 1 nhân viên khác.

![MODELS-LINKS drawio](https://github.com/trungpham27/DE-Data-Modeling-/assets/160450740/772d23f5-8236-40fc-a85d-c908a31a779d)

### 2.3. Mô hình hoá các SATELLITE
![MODELS-SATELLITES drawio](https://github.com/trungpham27/DE-Data-Modeling-/assets/160450740/6afe7af9-0cf2-41eb-a9e9-33cfc334d54b)

Các SATELLITE được xây dựng xung quanh các HUB và LINK, mỗi bảng là 1 nhóm các thuộc tính có sự tương đồng, biểu diễn cho 1 tính chất đặc trưng nào đó của HUB và LINK.
Các bảng SATELLITE đều có khóa chính là composite key tạo nên từ Hash Key ID của bảng HUB hoặc LINK mà nó liên kết và ngày nạp dữ liệu (LOAD_DTS). Ngoài ra, tất cả các bảng SATELLITE cũng có những cột chung như HASHDIFF và END_DTS (Dùng để lưu lại ngày dừng sử dụng của một quan sát, đồng thời cũng giúp  chúng ta truy vấn dễ dàng hơn)
Các HUB hoàn toàn có khả năng mở rộng thêm các SATELLITE mới khi doanh nghiệp phát triển, sau đây chỉ là một số SATELLITE dựa trên các thuộc tính của Relational Model gốc.
SATELLITE của H_CATEGORIES
- S_CATEGORIES_GENERAL, mang thông tin chung về phân loại sản phẩm

SATELLITE của H_SUPPLIERS
- S_SUPPLIERS_GENERAL, mang thông tin chung về nhà cung cấp sản phẩm
- S_SUPPLIERS_CONTACT, mang thông tin liên lạc của nhà cung cấp sản phẩm

SATELLITE của H_PRODUCTS
- S_PRODUCTS_GENERAL, mang thông tin chung về sản phẩm

SATELLITE của H_ORDERS
- S_ORDERS_DETAILS, mang thông tin chi tiết về đơn hàng (ngày giao, ngày yêu cầu, địa chỉ giao…)
  
SATELLITE của L_ORD_PROD
- L_ORD_PROD_DETAILS, mang thông tin chi tiết về từng sản phẩm trong các đơn hàng (số lượng, đơn giá, chiết khấu)
  
SATELLITE của H_SHIPPERS
- S_SHIPPERS_GENERAL, mang thông tin chung về người giao hàng
  
SATELLITE của H_CUSTOMERS
- S_CUSTOMERS_GENERAL, mang thông tin chung về khách hàng
- S_CUSTOMERS_CONTACT, mang thông tin liên lạc của khách hàng
  
SATELLITE của H_EMPLOYEES
- S_EMPLOYEES_GENERAL, mang thông tin chung về nhân viên
- S_EMPLOYEES_CONTACT, mang thông tin liên lạc của nhân viên
- S_EMPLOYEES_RESOURCE, mang các thông tin thêm, các tài liệu liên quan đến nhân viên

SATELLITE của HL_EE_MGR
- S_EFF_EE_MGR: Effectivity SATELLITE lưu trữ lịch sử mối quan hệ giữa nhân viên và người quản lý, nó sẽ chèn vào các quan sát mới mỗi khi nhân viên được quản lý bởi một người khác hoặc khi một người quản lý bắt đầu tiếp quản một nhân viên khác.

SATELLITE của H_REGION
- S_REGION_GENERAL, mang thông tin chung về khu vực

SATELLITE của H_TERRITORIES
- S_TERRITORIES_GENERAL, mang thông tin chung về vùng lãnh thổ

## 3. Xây dựng mô hình dữ liệu cho Data Mart với Star Schema
![MODELS-STAR-SCHEMA drawio](https://github.com/trungpham27/DE-Data-Modeling-/assets/160450740/b366e220-c555-4f44-8bdd-098f42c6b99e)

Danh mục yêu cầu nghiệp vụ mà nhóm nhận được với cơ sở dữ liệu này là từ phòng Kinh doanh với nhiệm vụ xây dựng mô hình dữ liệu để trích xuất các thông tin về Doanh thu và Số lượng sản phẩm đã bán theo Ngày, Nhân viên, Khách hàng và Sản phẩm (List of Business Requirements: Analysis of revenues and sold items by Date, Employee, Customer, Product).

Thông qua tìm hiểu và so sánh các mô hình dữ liệu, nhóm dễ dàng nhận thấy Dimensional Model là mô hình phù hợp nhất để mô hình hóa dữ liệu trong Data Mart vì mô hình này giúp tối ưu hóa truy vấn dữ liệu phân tích và dữ liệu cũng được hiển thị rất trực quan, dễ hiểu, tiện cho việc báo cáo và sử dụng số liệu từ các phòng ban trong công ty, bất kể họ có am hiểu sâu rộng về cơ sở dữ liệu công ty hay không.

Với yêu cầu về nghiệp vụ của phòng Kinh doanh và lượng thuộc tính cần thiết cho việc phân tích, nhóm lựa chọn mô hình đơn giản - Star Schema để cấu trúc dữ liệu để tránh tổn thất bộ nhớ và chi phí cho lượng dữ liệu không cần thiết khi sử dụng các mô hình phức tạp hơn. Tiếp đến, như đã đề cập ở phần Cơ sở lý thuyết của Dimensional Model thì những thực thể và các thuộc tính của những thực thể trong mô hình Star Schema có thể thay đổi tùy theo nhu cầu của từng phòng ban hay từng cá nhân trong mỗi phòng ban. Các mô hình dữ liệu trong mỗi Data Mart sẽ góp phần cấu thành nên Data Warehouse. Ví dụ đối với cơ sở dữ liệu mà nhóm đang thực hiện tại Đồ án này, phòng Marketing sẽ chủ yếu cần những dữ liệu liên quan đến khách hàng, sản phẩm… hơn một số thông tin khác nên trong mô hình dữ liệu có thể chỉ bao gồm những thông tin này. 

Với bảng Fact, nhóm sẽ bao gồm các thông tin mà phòng Kinh doanh đã yêu cầu bao gồm: Revenue và UnitsSold cùng với các thuộc tính DateID, EmployeeID, ProductID, CustomerID để nhân sự phòng ban này có thể phân tích doanh thu và số lượng sản phẩm đã bán theo các thuộc tính mong muốn ở các bảng Dimension mà chúng liên kết tới. Do vậy, khóa ngoại của bảng này cũng chính là các thuộc tính đó và khóa chính là composite key của các thuộc tính này. 
Với bảng Dimension của Date, ngoài DateID là khóa chính liên kết với bảng Fact, nhóm đặt thêm các thuộc tính là Ngày, Tuần, Tháng, Quý, Năm để tạo điều kiện thuận lợi nhất cho việc đánh giá, so sánh dữ liệu theo thời gian của phòng Kinh doanh. 

Với bảng Dimension của Employees, nhóm lấy các thuộc tính mô tả thông tin cơ bản và thông tin liên hệ của từ các Satellite liên kết với Hub của Employees ở mô hình Data Vault. Nhóm cũng thực hiện tương tự với các bảng Dimension của Products và Customers bằng việc tổng hợp thuộc tính từ các Satellite liên kết với Hub tương ứng, sau đó lược bỏ một số thuộc tính không mang ý nghĩa hiện tại với phòng Kinh doanh như Discontinued (dùng xác định sản phẩm đã dừng sản xuất).

## 4. Tạo mô hình dữ liệu cho Data Mart bằng truy vấn SQL 
(Chi tiết tại file SQL Script)





