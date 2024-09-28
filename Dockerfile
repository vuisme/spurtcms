# Sử dụng image Go chính thức từ DockerHub cho bước build
FROM golang:1.20-alpine AS build

# Cài đặt make và các dependencies cần thiết
RUN apk add --no-cache make gcc libc-dev

# Đặt thư mục làm việc là /app
WORKDIR /app

# Sao chép go.mod và go.sum vào container để tải dependencies
COPY go.mod go.sum ./
RUN go mod download

# Sao chép toàn bộ mã nguồn vào container
COPY . .

# Build ứng dụng Go sử dụng Makefile
RUN make buildwithview

# Sử dụng image Alpine nhỏ gọn để chạy ứng dụng
FROM alpine:latest

WORKDIR /app

# Sao chép các file từ quá trình build
COPY --from=build /app/build /app

# Expose port mà ứng dụng sẽ chạy (trùng với PORT bạn đặt trong biến môi trường)
EXPOSE 8080

# Thiết lập biến môi trường (nếu cần)
ENV PORT=8080

# Chạy ứng dụng
CMD ["./spurtcms-admin"]
