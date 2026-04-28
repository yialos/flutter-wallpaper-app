# Hướng Dẫn Bảo Trì Dự Án

## 🧹 Dọn Dẹp Định Kỳ

### Khi Nào Cần Dọn Dẹp?

Chạy `flutter clean` khi:
- ✅ Gặp lỗi build không rõ nguyên nhân
- ✅ Sau khi update Flutter SDK
- ✅ Sau khi thay đổi dependencies lớn
- ✅ Trước khi commit/push (để giảm dung lượng)
- ✅ Khi ổ đĩa gần đầy

### Lệnh Dọn Dẹp

```bash
# Dọn dẹp cơ bản (khuyến nghị)
flutter clean

# Dọn dẹp toàn bộ (nếu cần)
flutter clean
rm -rf .dart_tool
rm -rf build
flutter pub get
```

## 📦 Quản Lý Dependencies

### Cập Nhật Dependencies

```bash
# Kiểm tra packages lỗi thời
flutter pub outdated

# Cập nhật minor versions
flutter pub upgrade

# Cập nhật major versions (cẩn thận!)
# Sửa pubspec.yaml thủ công, sau đó:
flutter pub get
```

### Kiểm Tra Sau Khi Update

```bash
# Analyze code
dart analyze

# Format code
dart format .

# Run tests
flutter test

# Test trên device
flutter run -d chrome
```

## 🔍 Kiểm Tra Code Quality

### Trước Mỗi Commit

```bash
# 1. Format code
dart format .

# 2. Analyze
dart analyze

# 3. Check for issues
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Run tests (nếu có)
flutter test
```

### Checklist Commit

- [ ] Code đã format (`dart format .`)
- [ ] Không có errors (`dart analyze`)
- [ ] Tests pass (nếu có)
- [ ] Commit message rõ ràng
- [ ] Đã test trên ít nhất 1 platform

## 🗂️ Quản Lý Git

### Commit Messages Convention

```bash
# Format: <type>: <description>

# Types:
feat: Tính năng mới
fix: Sửa bug
docs: Cập nhật documentation
style: Format code, không thay đổi logic
refactor: Refactor code
test: Thêm/sửa tests
chore: Maintenance tasks
perf: Cải thiện performance
```

### Ví Dụ

```bash
git commit -m "feat: Add dark mode support"
git commit -m "fix: Fix category filter not working"
git commit -m "docs: Update README with installation steps"
git commit -m "chore: Clean up temporary files"
```

### Workflow Chuẩn

```bash
# 1. Pull latest changes
git pull

# 2. Make changes
# ... edit code ...

# 3. Check status
git status

# 4. Stage changes
git add .

# 5. Commit
git commit -m "feat: Your feature description"

# 6. Push
git push
```

## 🐛 Troubleshooting

### Lỗi Build

```bash
# Solution 1: Clean và rebuild
flutter clean
flutter pub get
flutter run

# Solution 2: Xóa cache
rm -rf .dart_tool
rm -rf build
flutter pub get

# Solution 3: Restart IDE
# Close và mở lại VS Code/Android Studio
```

### Lỗi Dependencies

```bash
# Solution 1: Xóa pubspec.lock
rm pubspec.lock
flutter pub get

# Solution 2: Downgrade package
# Sửa version trong pubspec.yaml
flutter pub get
```

### Lỗi Git

```bash
# Conflict khi pull
git pull
# Resolve conflicts manually
git add .
git commit -m "merge: Resolve conflicts"
git push

# Undo last commit (giữ changes)
git reset --soft HEAD~1

# Undo last commit (xóa changes)
git reset --hard HEAD~1
```

## 📊 Monitoring

### Kiểm Tra Dung Lượng

```bash
# Xem dung lượng thư mục
du -sh .
du -sh build/
du -sh .dart_tool/

# Windows
dir /s
```

### Kiểm Tra Performance

```bash
# Profile mode
flutter run --profile

# Release mode
flutter run --release

# Analyze performance
flutter analyze --watch
```

## 🔄 Backup Strategy

### Trước Khi Thay Đổi Lớn

```bash
# 1. Commit tất cả changes
git add .
git commit -m "chore: Backup before major changes"

# 2. Tạo branch mới
git checkout -b feature/new-feature

# 3. Làm việc trên branch mới
# ... make changes ...

# 4. Merge về main khi xong
git checkout main
git merge feature/new-feature
```

### Backup Định Kỳ

- ✅ Push lên GitHub mỗi ngày
- ✅ Tạo release tags cho các version quan trọng
- ✅ Backup local nếu cần (external drive)

## 📅 Lịch Bảo Trì

### Hàng Ngày
- [ ] Commit và push changes
- [ ] Run `dart analyze` trước khi commit

### Hàng Tuần
- [ ] Run `flutter clean`
- [ ] Check `flutter pub outdated`
- [ ] Review và merge pull requests

### Hàng Tháng
- [ ] Update dependencies
- [ ] Review và update documentation
- [ ] Check for Flutter SDK updates
- [ ] Create release tag nếu có version mới

## 🚀 Release Checklist

Trước khi release version mới:

- [ ] Update `CHANGELOG.md`
- [ ] Update version trong `pubspec.yaml`
- [ ] Run full test suite
- [ ] Test trên tất cả platforms
- [ ] Update documentation
- [ ] Create Git tag
- [ ] Build release artifacts
- [ ] Deploy to stores

## 📞 Hỗ Trợ

Nếu gặp vấn đề:
1. Check `TROUBLESHOOTING.md` (nếu có)
2. Search GitHub Issues
3. Check Flutter documentation
4. Ask on Stack Overflow

---

**Cập nhật lần cuối**: 2026-04-28
**Version**: 1.0.0
