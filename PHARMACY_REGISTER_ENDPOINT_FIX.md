# 🔧 تصحيح مشكلة Pharmacy Register Endpoint

## ❌ المشكلة

```
I/flutter ( 4394): ║ <!DOCTYPE html>
I/flutter ( 4394): ║ Cannot POST /auth/pharmacy/register
```

**السبب:** الـ Backend API لا يملك endpoint منفصل لـ `/auth/pharmacy/register`

---

## ✅ الحل

بدل استخدام endpoint منفصل، الآن نستخدم نفس endpoint `/auth/register` للصيدليات **لكن** مع إضافة:
- `role: "pharmacy"` - لتحديد أنها صيدلية
- `pharmacyName` - اسم الصيدلية
- `address` - عنوان الصيدلية
- `location` - إحداثيات الموقع بصيغة GeoJSON

---

## 📝 التغييرات المُطبقة

### 1. تحديث ApiConstants

**القديم:**
```dart
static const String pharmacyRegister = "/auth/pharmacy/register";
```

**الجديد:**
```dart
static const String pharmacyRegister = "/auth/register";
```

### 2. Request Body الذي يُرسل الآن

```json
{
  "username": "pharmacy_name",
  "email": "pharmacy@email.com",
  "phoneNumber": "01612345678",
  "password": "@Aa123456",
  "role": "pharmacy",           // ← يحدد أنها صيدلية
  "pharmacyName": "Pharmacy",
  "address": "Cairo",
  "location": {
    "type": "Point",
    "coordinates": [longitude, latitude]
  }
}
```

### 3. نفس Response من Backend

```json
{
  "message": "User registered successfully. Please verify your email.",
  "user": {
    "_id": "pharmacyId123",
    "username": "pharmacy_name",
    "email": "pharmacy@email.com",
    "phoneNumber": "01612345678",
    "role": "pharmacy",
    "isEmailVerified": false
  }
}
```

---

## 🔄 المنطق (Flow)

```
PharmacyRegisterStepTwoPage
    ↓
PharmacyRegisterRequestBody {
    role: "pharmacy",
    pharmacyName: "X",
    address: "Y",
    location: {coordinates: [lng, lat]}
}
    ↓
AuthCubit.registerPharmacy()
    ↓
AuthRepo.registerPharmacy()
    ↓
ApiService.pharmacyRegister()  ← still same method name
    ↓
ApiConstants.pharmacyRegister = "/auth/register"  ← but same endpoint!
    ↓
POST /auth/register  ← Backend API
    ↓
Backend يشوف role="pharmacy" → يعامله كصيدلية ✅
```

---

## 🎯 ملخص

| العنصر | القديم | الجديد |
|-------|--------|--------|
| **Endpoint URL** | `/auth/pharmacy/register` ❌ | `/auth/register` ✅ |
| **Method Name** | `pharmacyRegister()` | `pharmacyRegister()` (لم يتغير) |
| **Request** | Missing role, pharmacy details | ✅ Complete with all fields |
| **Backend** | Expected new endpoint | Uses existing register endpoint |

---

## 🚀 الآن جاهز للاختبار!

جرّب تسجيل صيدلية جديدة:

1. ادخل التطبيق
2. اختر "I'm a Pharmacy"
3. أدخل البيانات
4. اضغط Register

يجب أن يعمل بدون `Cannot POST` error! ✅
