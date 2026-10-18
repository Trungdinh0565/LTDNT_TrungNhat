# CookTime - Ứng dụng gợi ý món ăn

## 1. Giới thiệu
CookTime là ứng dụng Flutter hỗ trợ tìm kiếm món ăn và xem hướng dẫn nấu ăn thông qua REST API.
Dự án được xây dựng nhằm thực hành Clean Architecture, Repository Pattern, UseCase, quản lý trạng thái với Cubit và Dependency Injection bằng `get_it`.

## 2. Công nghệ sử dụng
- **Flutter / Dart:** Xây dựng ứng dụng đa nền tảng.
- **Clean Architecture:** Phân chia mã nguồn thành Presentation, Domain và Data.
- **flutter_bloc:** Quản lý trạng thái giao diện bằng Cubit.
- **get_it:** Đăng ký và cung cấp các dependency.
- **http:** Gửi HTTP request đến REST API.
- **TheMealDB:** Cung cấp dữ liệu món ăn.
- **flutter_test / Mockito:** Hỗ trợ kiểm thử.

## 3. Cấu trúc dự án
```text
lib/
├── domain/
│   ├── meal_entity.dart
│   ├── meal_repository.dart
│   └── meal_usecase/
│       └── search.dart
├── data/
│   ├── meal_model.dart
│   └── meal_repository_impl.dart
├── presentation/
│   ├── fridge_cubit.dart
│   └── fridge_page.dart
├── injection_container.dart
└── main.dart

test/
└── search_test.dart
```

## 4. Yêu cầu cài đặt
- Flutter SDK và Dart SDK tương thích với dự án.
- Git.
- Visual Studio Code hoặc Android Studio.
- Android Emulator hoặc thiết bị Android để chạy ứng dụng.

Kiểm tra môi trường:
```bash
flutter doctor
```

## 5. Cài đặt và chạy ứng dụng
### Bước 1: Clone repository
```bash
git clone https://github.com/Trungdinh0565/LTDNT_TrungNhat.git
cd LTDNT_TrungNhat
```
### Bước 2: Cài đặt dependencies
```bash
flutter pub get
```
### Bước 3: Chạy ứng dụng
Khởi động Android Emulator hoặc kết nối thiết bị, sau đó chạy:
```bash
flutter run
```
## 6. Cấu hình môi trường
Dự án sử dụng REST API để lấy dữ liệu món ăn.
Phiên bản hiện tại sử dụng endpoint công khai của TheMealDB và không yêu cầu cấu hình riêng, không cần tạo file `.env` hoặc `google-services.json` để chạy.
Không đưa mật khẩu, API key riêng tư hoặc thông tin xác thực vào repository công khai.

## 7. Chạy kiểm thử
Chạy toàn bộ test:
```bash
flutter test
```
Chạy riêng unit test cho UseCase:
```bash
flutter test test/search_test.dart
```
Chạy lệnh sau khi đã cấu hình annotation và file test tương ứng:
```bash
dart run build_runner build --delete-conflicting-outputs
```

## 8. Kiến trúc ứng dụng
### Presentation
Chứa giao diện và quản lý trạng thái. Widget tương tác với Cubit để thực hiện thao tác tìm kiếm và hiển thị kết quả.

### Domain
Chứa Entity, Repository abstraction và UseCase. Domain không phụ thuộc trực tiếp vào implementation của Data.

### Data
Triển khai Repository, xử lý việc lấy dữ liệu từ REST API và chuyển đổi dữ liệu trả về thành đối tượng phù hợp với Domain.

### Dependency Injection
`get_it` được sử dụng để đăng ký và cung cấp các dependency cho những thành phần cần sử dụng chúng.

## 9. Đóng góp
Dự án demo được thực hiện bởi nhóm sinh viên Đinh Tiến Trung & Lê Văn Nhật.

## 10. Tài liệu tham khảo
- [Flutter Documentation](https://docs.flutter.dev/)
- [TheMealDB](https://www.themealdb.com/)
- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [get_it](https://pub.dev/packages/get_it)
- [Mockito](https://pub.dev/packages/mockito)
