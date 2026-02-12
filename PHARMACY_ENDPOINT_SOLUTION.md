# 🚀 حل مشكلة Pharmacy Register - شرح شامل

## 📌 خلاصة المشكلة

```
❌ Error: Cannot POST /auth/pharmacy/register
```

الـ Backend API الحالي لا يملك endpoint منفصل للصيدليات!

---

## ✅ الحل المُطبق

### استخدام نفس endpoint `/auth/register` للجميع

الـ Backend API يدعم `role` field في request body، لذا:

```dart
// القديم ❌
POST /auth/pharmacy/register  // ← لا يوجد!

// الجديد ✅  
POST /auth/register  // ← موجود ويدعم role field
```

---

## 📊 المقارنة بين الطلبات

### 1. User Registration (عادي)

```json
{
  "username": "john_doe",
  "email": "john@example.com",
  "phoneNumber": "01012345678",
  "password": "@Password123"
}
```

**Endpoint:** POST `/auth/register`  
**Response:** User object بـ role = "user"

---

### 2. Pharmacy Registration (الجديد ✅)

```json
{
  "username": "alfa",
  "email": "ahmy@gmail.com",
  "phoneNumber": "01612345678",
  "password": "@Aa123456",
  "role": "pharmacy",                    ← ← ← الفرق الأساسي!
  "pharmacyName": "Pharmacy Name",       ← معلومات إضافية
  "address": "ZagazigCity",
  "location": {
    "type": "Point",
    "coordinates": [31.5021, 30.5877]    ← GeoJSON format
  }
}
```

**Endpoint:** POST `/auth/register`  (نفس الـ endpoint!)  
**Response:** User object بـ role = "pharmacy"

---

## 🔍 كيف يعرف Backend أنها صيدلية؟

الـ Backend يتحقق من الـ `role` field:

```javascript
// Backend logic (مثال)
if (body.role === "pharmacy") {
  // تسجيل كصيدلية
  // حفظ pharmacy data (name, address, location)
  // إضافة pharmacy-specific fields
} else {
  // تسجيل كمستخدم عادي
}
```

---

## 📈 Request Flow الآن

```
┌─────────────────────────────────────────────────────┐
│         PharmacyRegisterStepTwoPage                  │
│  - يجمع كل البيانات (username, email, etc)        │
│  - يضيف role: "pharmacy"                           │
│  - يضيف pharmacy-specific data                      │
└─────────────────────┬───────────────────────────────┘
                      │
                      ▼
        ┌─────────────────────────────┐
        │  PharmacyRegisterRequestBody │
        │  - role: "pharmacy" ✅      │
        │  - pharmacyName            │
        │  - address                 │
        │  - location (GeoJSON)      │
        └─────────────────┬───────────┘
                          │
                          ▼
            ┌─────────────────────────────────┐
            │  AuthCubit.registerPharmacy()    │
            │  - emit(loading)                │
            │  - call auth.registerPharmacy() │
            └─────────────────┬───────────────┘
                              │
                              ▼
          ┌──────────────────────────────────┐
          │  AuthRepo.registerPharmacy()      │
          │  - call apiService.pharmacyReg..│
          └─────────────────┬────────────────┘
                            │
                            ▼
        ┌─────────────────────────────────────────┐
        │  ApiService.pharmacyRegister()          │
        │  - call POST endpoint                  │
        │  - endpoint = "/auth/register" ✅      │
        └─────────────────┬───────────────────────┘
                          │
                          ▼
    ┌─────────────────────────────────────────────┐
    │  Retrofit/Dio                               │
    │  POST https://tiryak.vercel.app/auth/      │
    │        register                             │
    └─────────────────┬───────────────────────────┘
                      │
                      ▼
        ┌────────────────────────────────────┐
        │  Backend API (Backend Server)       │
        │  POST /auth/register               │
        │                                    │
        │  Checks: role === "pharmacy"  ✅   │
        │  Saves pharmacy data              │
        │  Returns PharmacyUser object       │
        └─────────────────┬──────────────────┘
                          │
                          ▼
            ┌──────────────────────────────────┐
            │  Response (200 Created)          │
            │  {                               │
            │    message: "...",               │
            │    user: {                       │
            │      id: "...",                  │
            │      username: "alfa",           │
            │      email: "ahmy@gmail.com",    │
            │      phoneNumber: "...",         │
            │      role: "pharmacy", ✅        │
            │      isEmailVerified: false      │
            │    }                             │
            │  }                               │
            └────────────────────────────────────┘
```

---

## 📝 الملفات المُعدَّلة

### ✅ 1. ApiConstants

**Before:**
```dart
static const String pharmacyRegister = "/auth/pharmacy/register";
```

**After:**
```dart
static const String pharmacyRegister = "/auth/register";
```

**File:** `lib/core/networking/api_constants.dart`

---

### ✅ 2. PharmacyRegisterRequestBody

**No changes needed** - الـ structure صحيح بالفعل!

```dart
Map<String, dynamic> toJson() => {
  'username': username,
  'email': email,
  'phoneNumber': phoneNumber,
  'password': password,
  'role': role,                    // ← يُرسل كـ "pharmacy"
  'pharmacyName': pharmacyName,
  'address': address,
  if (location != null) 'location': location,
};
```

**File:** `lib/features/auth/data/model/pharmacy_register_request_body.dart`

---

## 🧪 اختبار الآن

### الخطوات:

1. **تشغيل التطبيق:**
   ```bash
   flutter run
   ```

2. **في الـ UI:**
   - اختر "I'm a Pharmacy"
   - ملأ البيانات في Step One
   - ملأ البيانات في Step Two
   - اضغط Register

3. **المتوقع:**
   - ✅ Request ينجح
   - ✅ الرد يحتوي على user.role = "pharmacy"
   - ✅ ننتقل لصفحة تحقق البريد

4. **إذا حدث خطأ:**
   ```
   ❌ Cannot POST /auth/register
   ```
   - تحقق من الـ Backend Base URL في ApiConstants
   - تأكد من أن الـ Endpoint path صحيح

---

## 🔐 الفوائد

| الميزة | الفائدة |
|-------|---------|
| **Endpoint واحد** | أسهل في الـ Backend management |
| **Role-based** | يسهل إضافة roles أخرى مستقبلاً |
| **Flexible** | يدعم pharmacy-specific data عند الحاجة |
| **Scalable** | بنية قابلة للتوسع |

---

## 📚 Resources

- [Retrofit Documentation](https://github.com/trevorwang/retrofit.dart)
- [GeoJSON Format](https://en.wikipedia.org/wiki/GeoJSON)
- [REST API Best Practices](https://restfulapi.net/)

---

## ❓ الأسئلة الشائعة

### Q: هل يؤثر هذا على اللوجن العادي؟
**A:** لا، اللوجن بنفس الطريقة - endpoint واحد `/auth/login`

### Q: هل يمكن إضافة pharmacy data بعد التسجيل؟
**A:** نعم، في المستقبل يمكن حفظ pharmacy data في صفحة profile

### Q: ماذا لو أردنا endpoint منفصل لاحقاً؟
**A:** يكفي تغيير ApiConstants في سطر واحد!

```dart
// تغيير سطر واحد فقط
static const String pharmacyRegister = "/auth/pharmacy/register";
```
