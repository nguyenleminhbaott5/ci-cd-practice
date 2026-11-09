# ============================================================
# Dockerfile = công thức đóng gói trang web thành 1 image.
# Image = "hộp" chứa sẵn nginx + file HTML, chạy ở đâu cũng giống nhau.
# ============================================================

# Lấy image nginx bản alpine (rất nhẹ) làm nền.
# nginx là web server: nó sẽ phục vụ file HTML cho trình duyệt.
FROM nginx:alpine

# Chép 2 file của site vào thư mục mà nginx dùng để phục vụ web.
# Cú pháp: COPY <file trên máy build> <đường dẫn trong image>
# Nếu sau này thêm file mới (ảnh, js...) thì phải thêm vào dòng này.
COPY index.html style.css /usr/share/nginx/html/

# Không cần CMD: image nginx đã tự chạy nginx ở cổng 80 khi container khởi động.
