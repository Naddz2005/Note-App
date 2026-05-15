# 📝 Note_App

Ứng dụng ghi chú thời gian thực sử dụng Firebase Realtime Database.

---

# 🚀 Công nghệ sử dụng

- Framework: Flutter
- Ngôn ngữ: Dart
- Firebase:
  - Firebase Authentication
  - Firebase Realtime Database
  - Firebase Performance

---

# 📚 Thư viện sử dụng

- firebase_core
- firebase_auth
- firebase_database
- provider
- intl
- font_awesome_flutter

---

# 🎨 Font chữ

- Poppins
- Fredoka

---

# ✨ Chức năng chính

- Đăng ký / đăng nhập tài khoản
- Lưu ghi chú realtime bằng Firebase
- Chỉnh sửa ghi chú
- Tìm kiếm ghi chú
- Grid View / List View
- Dark Mode
- Profile người dùng
- Hiển thị tổng số note
- Gắn tag cho note

---

# 📱 Giao diện

- Material Design
- Responsive UI
- Custom Theme
- Dark / Light Mode

---

# ⚙️ Cách sử dụng

## Cách 1: Chạy trực tiếp bằng Android Studio

---

## Bước 1: Cài Git

Tải Git tại:

https://git-scm.com/downloads

---

## Bước 2: Cài Flutter SDK

Tải Flutter SDK tại:

https://docs.flutter.dev/install

Sau khi cài xong hãy kiểm tra:

```bash
flutter doctor
```

---

## Bước 3: Cài Android Studio

Tải Android Studio tại:

https://developer.android.com/studio

Khi cài đặt nhớ tích:

- Android SDK
- Android SDK Platform
- Android Virtual Device

---

## Bước 4: Clone project

Mở CMD tại thư mục muốn lưu project rồi chạy:

```bash
git clone https://github.com/Naddz2005/Note-App
```

---

## Bước 5: Mở project bằng Android Studio

- Mở Android Studio
- Chọn:

```text
Open
```

- Chọn thư mục:

```text
Note-App
```

- Đợi Android Studio load project

---

## Bước 6: Cài dependencies

Mở terminal trong Android Studio và chạy:

```bash
flutter pub get
```

---

## Bước 7: Kết nối thiết bị Android

Có 2 cách:

# Cách A: Điện thoại thật

## Bật Developer Options

Vào:

```text
Cài đặt -> Giới thiệu điện thoại -> Nhấn 7 lần vào "Số phiên bản"
```

## Bật USB Debugging

Vào:

```text
Developer Options -> USB Debugging
```

## Kết nối điện thoại với máy tính bằng cáp USB

---

# Cách B: Máy ảo Android

Trong Android Studio:

```text
Tools -> Device Manager
```

Tạo máy ảo Android rồi nhấn Start.

---

## Bước 8: Chạy project

Nhấn nút:

```text
▶ Run
```

hoặc chạy lệnh:

```bash
flutter run
```

---

# 🔥 Firebase

Project sử dụng:

- Firebase Authentication
- Firebase Realtime Database

Dữ liệu được lưu theo cấu trúc:

```text
Note_App
    └── user_uid
            ├── user_name
            ├── email
            ├── register_date
            └── notes
```

---

# 📂 Cấu trúc dữ liệu Note

```text
notes
    └── note_id
            ├── title
            ├── content
            ├── date_created
            ├── last_modified
            └── tags
```

---

# 👨‍💻 Người phát triển

Ngô Anh Đức

GitHub:

https://github.com/Naddz2005

---

# 📌 Lưu ý

Nếu project không chạy hãy thử:

```bash
flutter clean
flutter pub get
```

Sau đó chạy lại:

```bash
flutter run
```
