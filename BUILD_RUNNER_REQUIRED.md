# ⚠️ تحذير مهم - قبل تشغيل التطبيق

## الخطوة الأساسية الأولى والمهمة جداً:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### السبب:
الملفات الجديدة التالية تحتاج الملفات المولدة (.g.dart):

1. **pharmacy_register_request_body.dart** ← ينتج → **pharmacy_register_request_body.g.dart**
2. **pharmacy_register_response.dart** ← ينتج → **pharmacy_register_response.g.dart**

بدون تشغيل `build_runner`، لن تتمكن من:
- بناء التطبيق
- تشغيل التطبيق
- استخدام JSON serialization

### كيفية التشغيل:

#### على Windows (PowerShell/CMD):
```bash
cd c:\Users\1223\Desktop\tryiak
flutter pub run build_runner build --delete-conflicting-outputs
```

#### على macOS/Linux:
```bash
cd ~/path/to/tryiak
flutter pub run build_runner build --delete-conflicting-outputs
```

### إذا واجهت مشكلة:

```bash
# إذا فشل، جرب هذا:
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

---

✅ **بعد تشغيل هذا الأمر بنجاح، ستتم إزالة جميع الأخطاء!**
